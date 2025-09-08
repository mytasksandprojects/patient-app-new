import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:userapp/generated/l10n.dart';
import '../utilities/colors_constant.dart';

class FileUploadWidget extends StatefulWidget {
  final Function(File file, String fileName) onFileSelected;
  final VoidCallback? onFileCleared;
  final bool isUploading;
  final double uploadProgress;

  const FileUploadWidget({
    super.key,
    required this.onFileSelected,
    this.onFileCleared,
    this.isUploading = false,
    this.uploadProgress = 0.0,
  });

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  File? _selectedFile;
  String? _fileName;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _fileName = result.files.single.name;
        });

        // Notify parent widget about the selected file
        widget.onFileSelected(_selectedFile!, _fileName!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${S.of(context).LErrorPickingFile}${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFile = null;
      _fileName = null;
    });
    // Notify parent widget that file was cleared
    if (widget.onFileCleared != null) {
      widget.onFileCleared!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Upload area
            GestureDetector(
              onTap: widget.isUploading ? null : _pickFile,
              child: Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: ColorResources.bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedFile != null
                        ? Colors.green
                        : ColorResources.primaryColor.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/4,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _selectedFile != null
                              ? [Colors.green, Colors.green.shade600]
                              : [
                                  ColorResources.primaryColor,
                                  ColorResources.secondaryColor,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        _selectedFile != null
                            ? Icons.check_circle
                            : Icons.cloud_upload,
                        color: const Color(0xFF0f0f0f),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedFile != null
                          ? S.of(context).LFileSelected
                          : S.of(context).LTapToSelectFile,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: _selectedFile != null
                            ? Colors.green
                            : ColorResources.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.of(context).LSupportedFormats,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorResources.secondaryFontColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Selected file info
            if (_selectedFile != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fileName ?? S.of(context).LUnknownFile,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.green,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getFileSize(_selectedFile!, context),
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorResources.secondaryFontColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!widget.isUploading)
                      IconButton(
                        onPressed: _clearSelection,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ],

            // Upload progress
            if (widget.isUploading) ...[
              const SizedBox(height: 16),
              Column(
                children: [
                  LinearProgressIndicator(
                    value: widget.uploadProgress,
                    backgroundColor: ColorResources.primaryColor.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        ColorResources.primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).LUploadingProgress((widget.uploadProgress * 100).toInt()),
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorResources.secondaryFontColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getFileSize(File file, BuildContext context) {
    try {
      int sizeInBytes = file.lengthSync();
      double sizeInKB = sizeInBytes / 1024;
      double sizeInMB = sizeInKB / 1024;

      if (sizeInMB >= 1) {
        return "${sizeInMB.toStringAsFixed(2)} MB";
      } else {
        return "${sizeInKB.toStringAsFixed(2)} KB";
      }
    } catch (e) {
      return S.of(context).LUnknownSize;
    }
  }
}

