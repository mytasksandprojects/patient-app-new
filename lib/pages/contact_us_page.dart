import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/generated/l10n.dart';
import '../services/configuration_service.dart';
import '../utilities/colors_constant.dart';
import '../utilities/image_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/social_media_model.dart';
import '../services/social_media_servcie.dart';
import '../utilities/api_content.dart';
import '../widget/app_bar_widget.dart';
import '../widget/image_box_widget.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgColor,
      appBar: IAppBar.commonAppBar(title: S.of(context).LContactUs),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Image Section
          _buildHeaderSection(),
          
          const SizedBox(height: 30),
          
          // Title Section
         // _buildTitleSection(),
          
         // const SizedBox(height: 30),
          
          // Description Section
          _buildDescriptionSection(),
          
          const SizedBox(height: 30),
          
          // Contact Information Cards
          _buildContactInfoSection(),
          
          const SizedBox(height: 30),
          
          // Social Media Section
          _buildSocialMediaSection(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorResources.primaryColor.withOpacity(0.1),
            ColorResources.darkCardColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: SvgPicture.asset(
            ImageConstants.appShareImage,
            semanticsLabel: 'Contact Us',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorResources.primaryColor,
            ColorResources.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: ColorResources.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        S.of(context).LContactUs,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0f0f0f),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: FutureBuilder(
        future: ConfigurationService.getDataById(idName: "c_u_p_d_p_a"),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Text(
                  "${snapshot.data?.value}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    letterSpacing: 0.5,
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.6,
                  ),
                )
              : const Text(
                  "--",
                  style: TextStyle(color: Colors.white),
                );
        },
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).LContactUs, // Using existing translation key
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorResources.primaryColor,
          ),
        ),
        const SizedBox(height: 15),
        
        // Address Card
        _buildContactInfoCard(
          icon: Icons.location_on,
          title: S.of(context).LAddress,
          futureBuilder: ConfigurationService.getDataById(idName: "address"),
        ),
        
        const SizedBox(height: 15),
        
        // Phone Card
        _buildContactInfoCard(
          icon: Icons.phone,
          title: S.of(context).LPhone,
          futureBuilder: ConfigurationService.getDataById(idName: "phone"),
        ),
      ],
    );
  }

  Widget _buildContactInfoCard({
    required IconData icon,
    required String title,
    required Future futureBuilder,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorResources.primaryColor,
                  ColorResources.secondaryColor,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0f0f0f),
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: FutureBuilder(
              future: futureBuilder,
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorResources.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      snapshot.hasData ? "${snapshot.data?.value ?? "--"}" : "--",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).LFollowUs, // Using correct translation key
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorResources.primaryColor,
          ),
        ),
        const SizedBox(height: 15),
        
        FutureBuilder(
          future: SocialMediaService.getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorResources.darkCardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ColorResources.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  S.of(context).LNoLinksAvailable, // Using correct translation key
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              );
            }
            
            return ListView.separated(
              controller: scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data?.length ?? 0,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                SocialMediaModel socialMediaModel = snapshot.data![index];
                return _buildSocialMediaCard(socialMediaModel);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSocialMediaCard(SocialMediaModel socialMediaModel) {
    return GestureDetector(
      onTap: () async {
        if (socialMediaModel.url != null) {
          try {
            await launchUrl(
              Uri.parse(socialMediaModel.url!),
              mode: LaunchMode.externalApplication,
            );
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorResources.darkCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorResources.primaryColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: ColorResources.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: ColorResources.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: socialMediaModel.image == null
                    ? Icon(
                        Icons.link,
                        color: ColorResources.primaryColor,
                        size: 30,
                      )
                    : ImageBoxFillWidget(
                        imageUrl: "${ApiContents.imageUrl}/${socialMediaModel.image}",
                        boxFit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    socialMediaModel.title ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    S.of(context).LClickToVisit, // Using correct translation key
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorResources.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: ColorResources.primaryColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
