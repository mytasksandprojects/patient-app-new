import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/controller/medical_history_controller.dart';
import 'package:userapp/generated/l10n.dart';
import 'package:userapp/helpers/medical_history_translation_helper.dart';
import 'package:userapp/model/medical_history_model.dart';
import 'package:userapp/utilities/colors_constant.dart';
import 'package:userapp/widget/app_bar_widget.dart';

class MedicalHistoryPage extends StatelessWidget {
  const MedicalHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MedicalHistoryController controller = Get.put(MedicalHistoryController());
    
    return Scaffold(
      backgroundColor: ColorResources.bgColor,
      appBar: IAppBar.commonAppBar(title: S.of(context).LMedicalHistory),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryColor),
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).LErrorLoadingHistory,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.primaryFontColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorResources.secondaryFontColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.refreshMedicalHistory,
                  icon: const Icon(Icons.refresh),
                  label: Text(S.of(context).LRefresh),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.medicalHistoryData.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_outlined,
                  color: ColorResources.secondaryFontColor,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).LNoMedicalHistory,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: ColorResources.primaryFontColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.refreshMedicalHistory();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(context, controller.medicalHistoryData.value!.summary),
                const SizedBox(height: 16),
                _buildHistoryRecords(context, controller.medicalHistoryData.value!.history),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(BuildContext context, MedicalHistorySummary summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).LMedicalHistory,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorResources.primaryColor,
            ),
          ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    S.of(context).LTotalRecords,
                    summary.totalRecords.toString(),
                    Icons.description,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    S.of(context).LRecordTypes,
                    summary.recordTypesCount.toString(),
                    Icons.category,
                  ),
                ),
              ],
            ),
            if (summary.recordTypes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                S.of(context).LRecordTypes,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: summary.recordTypes.map((type) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ColorResources.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ColorResources.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      MedicalHistoryTranslationHelper.translateRecordType(type),
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorResources.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorResources.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: ColorResources.primaryColor, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorResources.primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: ColorResources.secondaryFontColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRecords(BuildContext context, MedicalHistoryRecords history) {
    List<RecordCategory> categories = history.getAllCategories();
    
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: categories.map((category) {
        String recordType = category.records.isNotEmpty 
            ? category.records.first.recordType 
            : '';
        
        return Column(
          children: [
            _buildCategoryCard(context, recordType, category),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String recordType, RecordCategory category) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: ColorResources.primaryColor,
        collapsedIconColor: ColorResources.primaryColor,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: ColorResources.primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: ColorResources.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                category.count.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                MedicalHistoryTranslationHelper.translateRecordType(recordType),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.primaryFontColor,
                ),
              ),
            ),
          ],
        ),
        children: category.records.map((record) {
          return _buildRecordItem(context, record);
        }).toList(),
      ),
    );
  }

  Widget _buildRecordItem(BuildContext context, MedicalRecord record) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColorResources.containerBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (record.createdAtFormatted != null) ...[
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: ColorResources.primaryColor),
                const SizedBox(width: 8),
                Text(
                  "${S.of(context).LCreatedAt}: ${record.createdAtFormatted}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorResources.secondaryFontColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          _buildRecordData(context, record),
        ],
      ),
    );
  }

  Widget _buildRecordData(BuildContext context, MedicalRecord record) {
    List<Widget> dataWidgets = [];
    
    record.data.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty && value.toString() != 'null') {
        String translatedKey = MedicalHistoryTranslationHelper.translateFieldName(key);
        String displayValue;
        
        if (MedicalHistoryTranslationHelper.isBooleanField(key)) {
          displayValue = MedicalHistoryTranslationHelper.formatBooleanValue(value);
        } else {
          displayValue = MedicalHistoryTranslationHelper.translateValue(value.toString());
        }
        
        dataWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    translatedKey,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorResources.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Text(
                    displayValue,
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorResources.primaryFontColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dataWidgets,
    );
  }
}
