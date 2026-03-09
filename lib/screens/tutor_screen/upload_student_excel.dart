import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/// Persistent Excel uploader + local store + delete-per-row
class StudentExcelUploader extends StatefulWidget {
  const StudentExcelUploader({super.key, required this.tutorId});
  final int tutorId;

  @override
  State<StudentExcelUploader> createState() => _StudentExcelUploaderState();
}

class _StudentExcelUploaderState extends State<StudentExcelUploader> {
  bool _uploading = false;
  String? _message;
  List<Map<String, String>> _rows = [];
  List<String> _headers = [];

  String get _localFileName => 'students_data_${widget.tutorId}.json';

  /// URLs
  String get fetchUrl =>
      'https://417sptdw-8003.inc1.devtunnels.ms/userapp/tutor_view_students/${widget.tutorId}/';

  final String uploadUrl =
      'https://417sptdw-8003.inc1.devtunnels.ms/userapp/student/upload/';
  final String studentDeleteBase =
      'https://417sptdw-8003.inc1.devtunnels.ms/userapp/student/';

  @override
  void initState() {
    super.initState();
    _loadLocalData();
    _fetchTutorStudents();
  }

  /// Local file handle
  Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_localFileName');
  }

  /// Save local data
  Future<void> _saveLocalData() async {
    try {
      final file = await _localFile();
      final jsonObj = {
        'headers': _headers,
        'rows': _rows,
      };
      await file.writeAsString(json.encode(jsonObj));
    } catch (e) {
      debugPrint('Failed saving local data: $e');
    }
  }

  /// Load local data
  Future<void> _loadLocalData() async {
    try {
      final file = await _localFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonObj = json.decode(content);
        final hdrs = List<String>.from(jsonObj['headers'] ?? []);
        final rows = List<Map<String, dynamic>>.from(jsonObj['rows'] ?? []);
        setState(() {
          _headers = hdrs;
          _rows = rows
              .map((m) => m.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Failed loading local data: $e');
    }
  }

  /// Clear local data
  Future<void> _clearLocalData() async {
    try {
      final file = await _localFile();
      if (await file.exists()) await file.delete();
      setState(() {
        _rows.clear();
        _headers.clear();
        _message = 'Local data cleared';
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to clear local data: $e';
      });
    }
  }

  /// Extract student ID
  String? _extractStudentId(Map<String, String> row) {
    for (final entry in row.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value.trim();
      if (key.contains('student') && key.contains('id') && value.isNotEmpty) return value;
    }
    for (final entry in row.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value.trim();
      if (key.contains('id') && value.isNotEmpty) return value;
    }
    for (final entry in row.entries) {
      final value = entry.value.trim();
      if (RegExp(r'^\d+$').hasMatch(value)) return value;
    }
    return null;
  }

  /// Delete row
  Future<void> _deleteRowAt(int index) async {
    final row = _rows[index];
    final id = _extractStudentId(row);

    if (id != null) {
      try {
        final uri = Uri.parse('$studentDeleteBase$id/');
        final resp = await http.delete(uri);
        if (resp.statusCode == 204 || resp.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deleted on server')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Server delete failed: ${resp.statusCode}')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Server delete error: $e')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No student ID found')));
    }

    setState(() {
      _rows.removeAt(index);
    });
    await _saveLocalData();
  }

  /// Pick and upload Excel
  Future<void> _pickAndUploadExcel() async {
    setState(() {
      _uploading = true;
      _message = null;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );

    if (result == null || result.files.isEmpty || result.files.first.bytes == null) {
      setState(() {
        _uploading = false;
        _message = "No file selected";
      });
      return;
    }

    final Uint8List fileBytes = result.files.first.bytes!;
    final String fileName = result.files.first.name;

    try {
      // Parse Excel
      final excel = Excel.decodeBytes(fileBytes);
      final sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName];

      if (sheet == null || sheet.rows.isEmpty) {
        setState(() {
          _message = "Excel has no data";
          _uploading = false;
        });
        return;
      }

      final parsedHeaders = sheet.rows.first.map((c) => c?.value.toString() ?? '').toList();
      final parsedRows = <Map<String, String>>[];
      for (int r = 1; r < sheet.rows.length; r++) {
        final row = sheet.rows[r];
        final mapRow = <String, String>{};
        for (int c = 0; c < parsedHeaders.length; c++) {
          mapRow[parsedHeaders[c]] = c < row.length ? (row[c]?.value.toString() ?? '') : '';
        }
        parsedRows.add(mapRow);
      }

      // Save locally
      setState(() {
        _headers = parsedHeaders;
        _rows.addAll(parsedRows);
      });
      await _saveLocalData();

      // Upload
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));
      request.fields['tutor_id'] = widget.tutorId.toString(); // if backend expects tutor_id

      final streamedResp = await request.send();
      final respBody = await streamedResp.stream.bytesToString();

      if (streamedResp.statusCode == 201 || streamedResp.statusCode == 200) {
        setState(() => _message = "Student data uploaded successfully");
        await _fetchTutorStudents();
      } else {
        setState(() => _message = "Upload failed: ${streamedResp.statusCode}, $respBody");
      }
    } catch (e) {
      setState(() => _message = "Error parsing/uploading: $e");
    } finally {
      setState(() => _uploading = false);
    }
  }

  /// Fetch tutor students
  Future<void> _fetchTutorStudents() async {
    try {
      final resp = await http.get(Uri.parse(fetchUrl));
      if (resp.statusCode == 200) {
        final List data = json.decode(resp.body);
        setState(() {
          _rows = data.map<Map<String, String>>((e) {
            return {
              "student_id": e["id"].toString(),
              "student_name": e["student_name"] ?? "",
              "department": e["department"] ?? "",
              "course": e["course"] ?? "",
            };
          }).toList();
          _headers = ["student_id", "student_name", "department", "course"];
        });
        await _saveLocalData();
      }
    } catch (e) {
      debugPrint('Fetch error: $e');
    }
  }

  /// Build table
  Widget _buildTable() {
    if (_rows.isEmpty || _headers.isEmpty) return const Center(child: Text("No data loaded"));

    final columns = _headers
        .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontWeight: FontWeight.bold))))
        .toList();
    columns.add(const DataColumn(label: Text('Actions')));

    final rows = _rows.asMap().entries.map((entry) {
      final idx = entry.key;
      final row = entry.value;
      final cells = _headers.map((h) => DataCell(Text(row[h] ?? ''))).toList();

      cells.add(DataCell(IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () async {
          final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete'),
                  content: const Text('Delete this student (local + server if possible)?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                  ],
                ),
              ) ??
              false;
          if (confirmed) await _deleteRowAt(idx);
        },
      )));

      return DataRow(cells: cells);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: columns, rows: rows),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Excel Upload"),
        actions: [
          IconButton(
            tooltip: 'Clear local data',
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Clear local data'),
                      content: const Text('This will remove all locally saved entries. Continue?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
                      ],
                    ),
                  ) ??
                  false;
              if (confirm) await _clearLocalData();
            },
          ),
        ],
      ),
      body: _uploading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload Excel"),
                    onPressed: _pickAndUploadExcel,
                  ),
                  const SizedBox(height: 12),
                  if (_message != null) ...[
                    Text(_message!, style: const TextStyle(fontSize: 14, color: Colors.green)),
                    const SizedBox(height: 12),
                  ],
                  Expanded(child: _buildTable()),
                ],
              ),
            ),
    );
  }
}
