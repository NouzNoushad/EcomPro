import 'package:ecom_pro/core/utils/colors.dart';
import 'package:ecom_pro/core/utils/extensions.dart';
import 'package:flutter/material.dart';

import 'image_container.dart';

imageBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: context.height * 0.2,
          padding: const EdgeInsets.all(15.0),
          color: AppColors.bgColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Profile Image',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImageContainer(
                    title: 'Camera',
                    icon: Icons.photo_camera,
                    radius: context.height * 0.030,
                    onTap: () {},
                  ),
                  ImageContainer(
                    title: 'Gallery',
                    icon: Icons.image,
                    radius: context.height * 0.030,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      });
}
