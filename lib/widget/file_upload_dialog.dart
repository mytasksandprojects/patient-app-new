import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/controller/patient_file_controller.dart';
import 'package:userapp/generated/l10n.dart';
import 'package:userapp/model/family_members_model.dart';
import 'package:userapp/widget/file_upload_widget.dart';
import 'package:userapp/services/patient_service.dart';
import '../utilities/colors_constant.dart';
import '../utilities/sharedpreference_constants.dart';
import '../widget/button_widget.dart';
import '../helpers/theme_helper.dart';

class FileUploadDialog {
  static void show(
    BuildContext context, {
    required PatientFileController controller,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorResources.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FileUploadBottomSheet(
          controller: controller,
        );
      },
    );
  }
}

class FileUploadBottomSheet extends StatefulWidget {
  final PatientFileController controller;

  const FileUploadBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  State<FileUploadBottomSheet> createState() => _FileUploadBottomSheetState();
}

class _FileUploadBottomSheetState extends State<FileUploadBottomSheet> {
  final TextEditingController _fileNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  File? _selectedFile;
  String? _originalFileName;
  String? _patientId;

  @override
  void initState() {
    super.initState();
    _getPatientId();
  }

  Future<void> _getPatientId() async {
    try {
      final patients = await PatientsService.getDataByUID();
      if (patients != null && patients.isNotEmpty) {
        setState(() {
          _patientId = patients.first.id?.toString() ?? "";
        });
      } else {
        setState(() {
          _patientId = "";
        });
      }
    } catch (e) {
      setState(() {
        _patientId = "";
      });
      debugPrint("Error getting patient ID: $e");
    }
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  void _onFileSelected(File file, String fileName) {
    setState(() {
      _selectedFile = file;
      _originalFileName = fileName;
      
      // Auto-fill the file name field with the original name (without extension)
      String nameWithoutExtension = fileName.contains('.')
          ? fileName.substring(0, fileName.lastIndexOf('.'))
          : fileName;
      _fileNameController.text = nameWithoutExtension;
    });
  }

  void _onFileCleared() {
    setState(() {
      _selectedFile = null;
      _originalFileName = null;
      _fileNameController.clear();
    });
  }

  Future<void> _uploadFile() async {
    if (_formKey.currentState!.validate() && _selectedFile != null && _patientId != null) {
      final success = await widget.controller.uploadFile(
        fileName: _fileNameController.text.trim(),
        file: _selectedFile!,
        patientId: _patientId!,
      );

      if (success) {
        Get.back(); // Close the dialog
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).LUploadPatientFile,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: ColorResources.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // File upload widget
                Text(
                  S.of(context).LSelectFile,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() => FileUploadWidget(
                  onFileSelected: _onFileSelected,
                  onFileCleared: _onFileCleared,
                  isUploading: widget.controller.isUploading.value,
                  uploadProgress: widget.controller.uploadProgress.value,
                )),
                const SizedBox(height: 20),

                // File name input
                if (_selectedFile != null) ...[
                  Text(
                    S.of(context).LFileName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                   // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: TextFormField(
                      controller: _fileNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: ThemeHelper().textInputDecoration(S.of(context).LEnterFileName),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return S.of(context).LPleaseEnterFileName;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Upload button
                Obx(() => SmallButtonsWidget(
                  title: widget.controller.isUploading.value ? S.of(context).LUploading : S.of(context).LUploadFile,
                  onPressed: widget.controller.isUploading.value || _selectedFile == null
                      ? null
                      : _uploadFile,
                )),
                const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

