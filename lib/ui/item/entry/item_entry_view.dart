import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/config/ps_colors.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/ps_dimens.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/provider/entry/item_entry_provider.dart';
import 'package:flutteradmotors/provider/gallery/gallery_provider.dart';
import 'package:flutteradmotors/repository/gallery_repository.dart';
import 'package:flutteradmotors/repository/product_repository.dart';
import 'package:flutteradmotors/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutteradmotors/ui/common/dialog/choose_camera_type_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/success_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradmotors/ui/common/ps_button_widget.dart';
import 'package:flutteradmotors/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:flutteradmotors/ui/common/ps_textfield_widget.dart';
import 'package:flutteradmotors/ui/common/ps_ui_widget.dart';
import 'package:flutteradmotors/ui/model/item/item.dart';
import 'package:flutteradmotors/ui/textfields/textfield_widget.dart';
import 'package:flutteradmotors/utils/ps_progress_dialog.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/Item_color.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/condition_of_item.dart';
import 'package:flutteradmotors/viewobject/default_photo.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/intent_holder/model_intent_holder.dart';
import 'package:flutteradmotors/viewobject/holder/item_entry_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/item_build_type.dart';
import 'package:flutteradmotors/viewobject/item_currency.dart';
import 'package:flutteradmotors/viewobject/item_fuel_type.dart';
import 'package:flutteradmotors/viewobject/item_location.dart';
import 'package:flutteradmotors/viewobject/item_price_type.dart';
import 'package:flutteradmotors/viewobject/item_seller_type.dart';
import 'package:flutteradmotors/viewobject/item_type.dart';
import 'package:flutteradmotors/viewobject/manufacturer.dart';
import 'package:flutteradmotors/viewobject/model.dart';
import 'package:flutteradmotors/viewobject/product.dart';
import 'package:flutteradmotors/viewobject/transmission.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class ItemEntryView extends StatefulWidget {
  static int pageNumber = 0;
  static int numberOfUploadedImages = 0;
  const ItemEntryView(
      {Key key, this.flag, this.item, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  final String flag;
  final Product item;
  static List<Asset> images = <Asset>[];
  static GalleryProvider galleryProvider;
  static Asset firstSelectedImageAsset;
  static Asset secondSelectedImageAsset;
  static Asset thirdSelectedImageAsset;
  static Asset fouthSelectedImageAsset;
  static Asset fifthSelectedImageAsset;
  static String firstCameraImagePath;
  static String secondCameraImagePath;
  static String thirdCameraImagePath;
  static String fouthCameraImagePath;
  static String fifthCameraImagePath;
  static bool isSelectedFirstImagePath = false;
  static bool isSelectedSecondImagePath = false;
  static bool isSelectedThirdImagePath = false;
  static bool isSelectedFouthImagePath = false;
  static bool isSelectedFifthImagePath = false;
  static Asset defaultAssetImage;
  @override
  State<StatefulWidget> createState() => _ItemEntryViewState();
}

class _ItemEntryViewState extends State<ItemEntryView> {
  @override
  void initState() {
    ItemEntryView.pageNumber = 0;
    ItemEntryView.numberOfUploadedImages = 0;
    ItemEntryView.images = <Asset>[];
    ItemEntryView.firstSelectedImageAsset = ItemEntryView.defaultAssetImage;
    ItemEntryView.secondSelectedImageAsset = ItemEntryView.defaultAssetImage;
    ItemEntryView.thirdSelectedImageAsset = ItemEntryView.defaultAssetImage;
    ItemEntryView.fouthSelectedImageAsset = ItemEntryView.defaultAssetImage;
    ItemEntryView.fifthSelectedImageAsset = ItemEntryView.defaultAssetImage;
    ItemEntryView.firstCameraImagePath = null;
    ItemEntryView.secondCameraImagePath = null;
    ItemEntryView.thirdCameraImagePath = null;
    ItemEntryView.fouthCameraImagePath = null;
    ItemEntryView.fifthCameraImagePath = null;
    ItemEntryView.isSelectedFirstImagePath = false;
    ItemEntryView.isSelectedSecondImagePath = false;
    ItemEntryView.isSelectedThirdImagePath = false;
    ItemEntryView.isSelectedFouthImagePath = false;
    ItemEntryView.isSelectedFifthImagePath = false;
    super.initState();
  }

  ProductRepository repo1;
  GalleryRepository galleryRepository;
  ItemEntryProvider _itemEntryProvider;
  PsValueHolder valueHolder;

  /// user input info
  final TextEditingController userInputListingTitle = TextEditingController();
  final TextEditingController userInputPlateNumber = TextEditingController();
  final TextEditingController userInputEnginePower = TextEditingController();
  final TextEditingController userInputMileage = TextEditingController();
  final TextEditingController userInputLicenseExpDate = TextEditingController();
  final TextEditingController userInputYear = TextEditingController();
  final TextEditingController userInputSteeringPosition =
      TextEditingController();
  final TextEditingController userInputNumOfOwner = TextEditingController();
  final TextEditingController userInputTrimName = TextEditingController();
  final TextEditingController userInputVehicleId = TextEditingController();
  final TextEditingController userInputMaximumPassenger =
      TextEditingController();
  final TextEditingController userInputNumOfDoor = TextEditingController();
  final TextEditingController userInputPriceUnit = TextEditingController();

  final TextEditingController userInputBrand = TextEditingController();
  final TextEditingController userInputHighLightInformation =
      TextEditingController();
  final TextEditingController userInputDescription = TextEditingController();
  final TextEditingController userInputDealOptionText = TextEditingController();
  final TextEditingController userInputLattitude = TextEditingController();
  final TextEditingController userInputLongitude = TextEditingController();
  final TextEditingController userInputAddress = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();
  final MapController mapController = MapController();

  /// api info
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController transmissionController = TextEditingController();
  final TextEditingController itemColorController = TextEditingController();
  final TextEditingController itemFuelTypeController = TextEditingController();
  final TextEditingController itemBuildTypeController = TextEditingController();
  final TextEditingController itemSellerTypeController =
      TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController itemConditionController = TextEditingController();
  final TextEditingController priceTypeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dealOptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  LatLng latlng;
  final double zoom = 16;
  bool bindDataFirstTime = true;
  // New Images From Image Picker

  // New Images Checking from Image Picker

  String isShopCheckbox = '1';

  // ProgressDialog progressDialog;

  // File file;

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);

    Future<dynamic> uploadImage(String itemId) async {
      print(itemId);
      print("################################################################");
      bool _isFirstDone = ItemEntryView.isSelectedFirstImagePath;
      bool _isSecondDone = ItemEntryView.isSelectedSecondImagePath;
      bool _isThirdDone = ItemEntryView.isSelectedThirdImagePath;
      bool _isFouthDone = ItemEntryView.isSelectedFouthImagePath;
      bool _isFifthDone = ItemEntryView.isSelectedFifthImagePath;

      if (!PsProgressDialog.isShowing()) {
        if (!ItemEntryView.isSelectedFirstImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image1_uploading'));
        }
      }

      if (ItemEntryView.isSelectedFirstImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await ItemEntryView.galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.firstImageId,
                ItemEntryView.firstSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        ItemEntryView.firstCameraImagePath,
                        PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        ItemEntryView.firstSelectedImageAsset,
                        PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          ItemEntryView.isSelectedFirstImagePath = false;
          _isFirstDone = ItemEntryView.isSelectedFirstImagePath;
          print('1 image uploaded');
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!ItemEntryView.isSelectedSecondImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image2_uploading'));
        }
      }

      if (ItemEntryView.isSelectedSecondImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await ItemEntryView.galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.secondImageId,
                ItemEntryView.secondSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        ItemEntryView.secondCameraImagePath,
                        PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        ItemEntryView.secondSelectedImageAsset,
                        PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          ItemEntryView.isSelectedSecondImagePath = false;
          _isSecondDone = ItemEntryView.isSelectedSecondImagePath;
          print('2 image uploaded');
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!ItemEntryView.isSelectedThirdImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image3_uploading'));
        }
      }

      if (ItemEntryView.isSelectedThirdImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await ItemEntryView.galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.thirdImageId,
                ItemEntryView.thirdSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        ItemEntryView.thirdCameraImagePath,
                        PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        ItemEntryView.thirdSelectedImageAsset,
                        PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          ItemEntryView.isSelectedThirdImagePath = false;
          _isThirdDone = ItemEntryView.isSelectedThirdImagePath;
          print('3 image uploaded');
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!ItemEntryView.isSelectedFouthImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image4_uploading'));
        }
      }

      if (ItemEntryView.isSelectedFouthImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await ItemEntryView.galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.fourthImageId,
                ItemEntryView.fouthSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        ItemEntryView.fouthCameraImagePath,
                        PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        ItemEntryView.fouthSelectedImageAsset,
                        PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          ItemEntryView.isSelectedFouthImagePath = false;
          _isFouthDone = ItemEntryView.isSelectedFouthImagePath;
          print('4 image uploaded');
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!ItemEntryView.isSelectedFifthImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image5_uploading'));
        }
      }

      if (ItemEntryView.isSelectedFifthImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await ItemEntryView.galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.fiveImageId,
                ItemEntryView.fifthSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        ItemEntryView.fifthCameraImagePath,
                        PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        ItemEntryView.fifthSelectedImageAsset,
                        PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          print('5 image uploaded');
          ItemEntryView.isSelectedFifthImagePath = false;
          _isFifthDone = ItemEntryView.isSelectedFifthImagePath;
        }
      }

      PsProgressDialog.dismissDialog();

      if (!(_isFirstDone ||
          _isSecondDone ||
          _isThirdDone ||
          _isFouthDone ||
          _isFifthDone)) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                message: Utils.getString(context, 'item_entry_item_uploaded'),
                onPressed: () async {
                  Navigator.pop(context, true);
                },
              );
            });
      }
      return;
    }

    repo1 = Provider.of<ProductRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    widget.animationController.forward();
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemEntryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  _itemEntryProvider = ItemEntryProvider(
                      repo: repo1, psValueHolder: valueHolder);

                  _itemEntryProvider.item = widget.item;

                  latlng = LatLng(
                      double.parse(
                          _itemEntryProvider.psValueHolder.locationLat),
                      double.parse(
                          _itemEntryProvider.psValueHolder.locationLng));
                  if (_itemEntryProvider.itemLocationId != null ||
                      _itemEntryProvider.itemLocationId != '')
                    _itemEntryProvider.itemLocationId =
                        _itemEntryProvider.psValueHolder.locationId;
                  if (userInputLattitude.text.isEmpty)
                    userInputLattitude.text =
                        _itemEntryProvider.psValueHolder.locationLat;
                  if (userInputLongitude.text.isEmpty)
                    userInputLongitude.text =
                        _itemEntryProvider.psValueHolder.locationLng;
                  _itemEntryProvider.getItemFromDB(widget.item.id);

                  return _itemEntryProvider;
                }),
            ChangeNotifierProvider<GalleryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  ItemEntryView.galleryProvider =
                      GalleryProvider(repo: galleryRepository);
                  if (widget.flag == PsConst.EDIT_ITEM) {
                    ItemEntryView.galleryProvider.loadImageList(
                        widget.item.defaultPhoto.imgParentId,
                        PsConst.ITEM_TYPE);
                  }
                  return ItemEntryView.galleryProvider;
                }),
          ],
          child: Scaffold(
            appBar: AppBar(
              brightness: Utils.getBrightnessForAppBar(context),
              backgroundColor: Utils.isLightMode(context)
                  ? PsColors.mainColor
                  : Colors.black12,
              title: Text(
                Utils.getString(context, 'post_your_listing'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: PsColors.white, fontWeight: FontWeight.bold),
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: AnimatedBuilder(
                  animation: widget.animationController,
                  child: Container(
                    color: PsColors.backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /* Padding(
                          padding: const EdgeInsets.only(
                              top: PsDimens.space16,
                              left: PsDimens.space10,
                              right: PsDimens.space10),
                          child: Text(
                              Utils.getString(
                                  context, 'item_entry__listing_today'),
                              style: Theme.of(context).textTheme.bodyText2),
                        ),*/
                        /* ItemEntryView.pageNumber >= 2
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: PsDimens.space16,
                                        left: PsDimens.space10,
                                        right: PsDimens.space10,
                                        bottom: PsDimens.space10),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              Utils.getString(context,
                                                  'item_entry__choose_photo_showcase'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2),
                                        ),
                                        Text(' *',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: PsColors.mainColor))
                                      ],
                                    ),
                                  ),

                                  //  _largeSpacingWidget,
                                  Consumer<GalleryProvider>(builder:
                                      (BuildContext context,
                                          GalleryProvider provider,
                                          Widget child) {
                                    if (provider != null &&
                                        provider.galleryList.data.isNotEmpty) {
                                      for (int imageId = 0;
                                          imageId <
                                              provider.galleryList.data.length;
                                          imageId++) {
                                        if (imageId == 0) {
                                          _itemEntryProvider.firstImageId =
                                              provider.galleryList.data[imageId]
                                                  .imgId;
                                        }
                                        if (imageId == 1) {
                                          _itemEntryProvider.secondImageId =
                                              provider.galleryList.data[imageId]
                                                  .imgId;
                                        }
                                        if (imageId == 2) {
                                          _itemEntryProvider.thirdImageId =
                                              provider.galleryList.data[imageId]
                                                  .imgId;
                                        }
                                        if (imageId == 3) {
                                          _itemEntryProvider.fourthImageId =
                                              provider.galleryList.data[imageId]
                                                  .imgId;
                                        }
                                        if (imageId == 4) {
                                          _itemEntryProvider.fiveImageId =
                                              provider.galleryList.data[imageId]
                                                  .imgId;
                                        }
                                      }
                                    }

                                    return ImageUploadHorizontalList(
                                      flag: widget.flag,
                                      images: images,
                                      selectedImageList:
                                          galleryProvider.selectedImageList,
                                      updateImages: updateImages,
                                      updateImagesFromCustomCamera:
                                          updateImagesFromCustomCamera,
                                      firstImagePath: firstSelectedImageAsset,
                                      secondImagePath: secondSelectedImageAsset,
                                      thirdImagePath: thirdSelectedImageAsset,
                                      fouthImagePath: fouthSelectedImageAsset,
                                      fifthImagePath: fifthSelectedImageAsset,
                                      firstCameraImagePath:
                                          firstCameraImagePath,
                                      secondCameraImagePath:
                                          secondCameraImagePath,
                                      thirdCameraImagePath:
                                          thirdCameraImagePath,
                                      fouthCameraImagePath:
                                          fouthCameraImagePath,
                                      fifthCameraImagePath:
                                          fifthCameraImagePath,
                                    );
                                  }),
                                ],
                              )
                            : Container(),*/

                        //
                        Consumer<ItemEntryProvider>(builder:
                            (BuildContext context, ItemEntryProvider provider,
                                Widget child) {
                          if (provider != null &&
                              provider.item != null &&
                              provider.item.id != null) {
                            if (bindDataFirstTime) {
                              userInputListingTitle.text = provider.item.title;
                              manufacturerController.text =
                                  provider.item.manufacturer.name;
                              modelController.text = provider.item.model.name;
                              userInputPlateNumber.text =
                                  provider.item.plateNumber;
                              userInputEnginePower.text =
                                  provider.item.enginePower;
                              transmissionController.text =
                                  provider.item.transmission.name;
                              userInputMileage.text = provider.item.mileage;
                              userInputLicenseExpDate.text =
                                  provider.item.licenseExpirationDate;
                              userInputYear.text = provider.item.year;
                              itemColorController.text =
                                  provider.item.itemColor.colorValue;
                              itemFuelTypeController.text =
                                  provider.item.fuelType.name;
                              userInputSteeringPosition.text =
                                  provider.item.steeringPosition;
                              userInputNumOfOwner.text =
                                  provider.item.noOfOwner;
                              userInputTrimName.text = provider.item.vehicleId;
                              itemBuildTypeController.text =
                                  provider.item.buildType.name;
                              userInputMaximumPassenger.text =
                                  provider.item.maxPassengers;
                              userInputNumOfDoor.text = provider.item.noOfDoors;
                              itemSellerTypeController.text =
                                  provider.item.sellerType.name;
                              userInputPriceUnit.text = provider.item.priceUnit;

                              userInputHighLightInformation.text =
                                  provider.item.highlightInformation;
                              userInputDescription.text =
                                  provider.item.description;
                              // userInputDealOptionText.text =
                              //     provider.item.data.dealOptionRemark;
                              userInputLattitude.text = provider.item.lat;
                              userInputLongitude.text = provider.item.lng;
                              userInputAddress.text = provider.item.address;
                              userInputPrice.text = provider.item.price;

                              typeController.text = provider.item.itemType.name;
                              itemConditionController.text =
                                  provider.item.conditionOfItem.name;
                              priceTypeController.text =
                                  provider.item.itemPriceType.name;
                              priceController.text =
                                  provider.item.itemCurrency.currencySymbol;
                              locationController.text =
                                  provider.item.itemLocation.name;

                              provider.manufacturerId =
                                  provider.item.manufacturer.id;
                              provider.modelId = provider.item.model.id;
                              provider.transmissionId =
                                  provider.item.transmissionId;
                              provider.itemColorId = provider.item.itemColor.id;
                              provider.fuelTypeId = provider.item.fuelType.id;
                              provider.buildTypeId = provider.item.buildType.id;
                              provider.sellerTypeId =
                                  provider.item.sellerType.id;
                              provider.itemTypeId = provider.item.itemType.id;
                              provider.itemConditionId =
                                  provider.item.conditionOfItem.id;
                              provider.itemCurrencyId =
                                  provider.item.itemCurrency.id;
                              provider.itemLocationId =
                                  provider.item.itemLocation.id;
                              provider.itemPriceTypeId =
                                  provider.item.itemPriceType.id;
                              bindDataFirstTime = false;
                              if (provider.item.licenceStatus == '1') {
                                provider.isLicenseCheckBoxSelect = true;
                                LicenseCheckbox(
                                  provider: provider,
                                  onCheckBoxClick: () {
                                    if (mounted) {
                                      setState(() {
                                        updateLicenseCheckBox(
                                            context, provider);
                                      });
                                    }
                                  },
                                );
                              } else {
                                provider.isLicenseCheckBoxSelect = false;

                                LicenseCheckbox(
                                  provider: provider,
                                  onCheckBoxClick: () {
                                    if (mounted) {
                                      setState(() {
                                        updateLicenseCheckBox(
                                            context, provider);
                                      });
                                    }
                                  },
                                );
                              }
                              if (provider.item.businessMode == '1') {
                                provider.isCheckBoxSelect = true;
                                _BusinessModeCheckbox();
                              } else {
                                provider.isCheckBoxSelect = false;

                                _BusinessModeCheckbox();
                              }
                            }
                          }
                          return AllControllerTextWidget(
                            userInputListingTitle: userInputListingTitle,
                            userInputPlateNumber: userInputPlateNumber,
                            userInputEnginePower: userInputEnginePower,
                            userInputMileage: userInputMileage,
                            userInputLicenseExpDate: userInputLicenseExpDate,
                            userInputYear: userInputYear,
                            userInputSteeringPosition:
                                userInputSteeringPosition,
                            userInputNumOfOwner: userInputNumOfOwner,
                            userInputTrimName: userInputTrimName,
                            userInputVehicleId: userInputVehicleId,
                            userInputMaximumPassenger:
                                userInputMaximumPassenger,
                            userInputNumOfDoor: userInputNumOfDoor,
                            userInputPriceUnit: userInputPriceUnit,
                            manufacturerController: manufacturerController,
                            modelController: modelController,
                            transmissionController: transmissionController,
                            itemColorController: itemColorController,
                            itemFuelTypeController: itemFuelTypeController,
                            itemBuildTypeController: itemBuildTypeController,
                            itemSellerTypeController: itemSellerTypeController,
                            typeController: typeController,
                            itemConditionController: itemConditionController,
                            userInputBrand: userInputBrand,
                            priceTypeController: priceTypeController,
                            priceController: priceController,
                            userInputHighLightInformation:
                                userInputHighLightInformation,
                            userInputDescription: userInputDescription,
                            dealOptionController: dealOptionController,
                            userInputDealOptionText: userInputDealOptionText,
                            locationController: locationController,
                            userInputLattitude: userInputLattitude,
                            userInputLongitude: userInputLongitude,
                            userInputAddress: userInputAddress,
                            userInputPrice: userInputPrice,
                            mapController: mapController,
                            zoom: zoom,
                            flag: widget.flag,
                            item: widget.item,
                            provider: provider,
                            galleryProvider: ItemEntryView.galleryProvider,
                            latlng: latlng,
                            uploadImage: (String itemId) {
                              if (ItemEntryView.isSelectedFirstImagePath ||
                                  ItemEntryView.isSelectedSecondImagePath ||
                                  ItemEntryView.isSelectedThirdImagePath ||
                                  ItemEntryView.isSelectedFouthImagePath ||
                                  ItemEntryView.isSelectedFifthImagePath) {
                                uploadImage(itemId);
                              }
                            },
                            isSelectedFirstImagePath:
                                ItemEntryView.isSelectedFirstImagePath,
                            isSelectedSecondImagePath:
                                ItemEntryView.isSelectedSecondImagePath,
                            isSelectedThirdImagePath:
                                ItemEntryView.isSelectedThirdImagePath,
                            isSelectedFouthImagePath:
                                ItemEntryView.isSelectedFouthImagePath,
                            isSelectedFifthImagePath:
                                ItemEntryView.isSelectedFifthImagePath,
                          );
                        })
                      ],
                    ),
                  ),
                  builder: (BuildContext context, Widget child) {
                    return child;
                  }),
            ),
          )),
    );
  }
}

////////////////////////////////////submit form ///////////////////////////////////////////////////////////////////////
class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget({
    Key key,
    this.userInputListingTitle,
    this.userInputPlateNumber,
    this.userInputEnginePower,
    this.userInputMileage,
    this.userInputLicenseExpDate,
    this.userInputYear,
    this.userInputSteeringPosition,
    this.userInputNumOfOwner,
    this.userInputTrimName,
    this.userInputVehicleId,
    this.userInputMaximumPassenger,
    this.userInputNumOfDoor,
    this.userInputPriceUnit,
    this.manufacturerController,
    this.modelController,
    this.transmissionController,
    this.itemColorController,
    this.itemFuelTypeController,
    this.itemBuildTypeController,
    this.itemSellerTypeController,
    this.typeController,
    this.itemConditionController,
    this.userInputBrand,
    this.priceTypeController,
    this.priceController,
    this.userInputHighLightInformation,
    this.userInputDescription,
    this.dealOptionController,
    this.userInputDealOptionText,
    this.locationController,
    this.userInputLattitude,
    this.userInputLongitude,
    this.userInputAddress,
    this.userInputPrice,
    this.mapController,
    this.provider,
    this.latlng,
    this.zoom,
    this.flag,
    this.item,
    this.uploadImage,
    this.galleryProvider,
    this.isSelectedFirstImagePath,
    this.isSelectedSecondImagePath,
    this.isSelectedThirdImagePath,
    this.isSelectedFouthImagePath,
    this.isSelectedFifthImagePath,
  }) : super(key: key);

  final TextEditingController userInputListingTitle;
  final TextEditingController userInputPlateNumber;
  final TextEditingController userInputEnginePower;
  final TextEditingController userInputMileage;
  final TextEditingController userInputLicenseExpDate;
  final TextEditingController userInputYear;
  final TextEditingController userInputSteeringPosition;
  final TextEditingController userInputNumOfOwner;
  final TextEditingController userInputTrimName;
  final TextEditingController userInputVehicleId;
  final TextEditingController userInputMaximumPassenger;
  final TextEditingController userInputNumOfDoor;
  final TextEditingController userInputPriceUnit;
  final TextEditingController manufacturerController;
  final TextEditingController modelController;
  final TextEditingController transmissionController;
  final TextEditingController itemColorController;
  final TextEditingController itemFuelTypeController;
  final TextEditingController itemBuildTypeController;
  final TextEditingController itemSellerTypeController;
  final TextEditingController typeController;
  final TextEditingController itemConditionController;
  final TextEditingController userInputBrand;
  final TextEditingController priceTypeController;
  final TextEditingController priceController;
  final TextEditingController userInputHighLightInformation;
  final TextEditingController userInputDescription;
  final TextEditingController dealOptionController;
  final TextEditingController userInputDealOptionText;
  final TextEditingController locationController;
  final TextEditingController userInputLattitude;
  final TextEditingController userInputLongitude;
  final TextEditingController userInputAddress;
  final TextEditingController userInputPrice;
  final MapController mapController;
  final ItemEntryProvider provider;
  final double zoom;
  final String flag;
  final Product item;
  final LatLng latlng;
  final Function uploadImage;
  final GalleryProvider galleryProvider;
  final bool isSelectedFirstImagePath;
  final bool isSelectedSecondImagePath;
  final bool isSelectedThirdImagePath;
  final bool isSelectedFouthImagePath;
  final bool isSelectedFifthImagePath;

  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  VideoPlayerController _controller;

  String selectedTransmation = "";
  String urlVideo;
  bool loading = false;
  List<Item> transmission = [
    Item(name: 'Automatic', selected: false),
    Item(name: 'Manual', selected: false),
    Item(name: 'Tiptronic', selected: false),
  ];
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  dynamic updateImages(List<Asset> resultList, int index) {
    if (index == -1) {
      ItemEntryView.firstSelectedImageAsset = ItemEntryView.defaultAssetImage;
      ItemEntryView.secondSelectedImageAsset = ItemEntryView.defaultAssetImage;
      ItemEntryView.thirdSelectedImageAsset = ItemEntryView.defaultAssetImage;
      ItemEntryView.fouthSelectedImageAsset = ItemEntryView.defaultAssetImage;
      ItemEntryView.fifthSelectedImageAsset = ItemEntryView.defaultAssetImage;
    }
    if (mounted) {
      setState(() {
        ItemEntryView.images = resultList;
        if (resultList.isEmpty) {
          ItemEntryView.firstSelectedImageAsset =
              ItemEntryView.defaultAssetImage;
          ItemEntryView.isSelectedFirstImagePath = false;
          ItemEntryView.secondSelectedImageAsset =
              ItemEntryView.defaultAssetImage;
          ItemEntryView.isSelectedSecondImagePath = false;
          ItemEntryView.thirdSelectedImageAsset =
              ItemEntryView.defaultAssetImage;
          ItemEntryView.isSelectedThirdImagePath = false;
          ItemEntryView.fouthSelectedImageAsset =
              ItemEntryView.defaultAssetImage;
          ItemEntryView.isSelectedFouthImagePath = false;
          ItemEntryView.fifthSelectedImageAsset =
              ItemEntryView.defaultAssetImage;
          ItemEntryView.isSelectedFifthImagePath = false;
        }
        //for single select image
        if (index == 0) {
          ItemEntryView.firstSelectedImageAsset = resultList[0];
          ItemEntryView.isSelectedFirstImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
        if (index == 1) {
          ItemEntryView.secondSelectedImageAsset = resultList[0];
          ItemEntryView.isSelectedSecondImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
        if (index == 2) {
          ItemEntryView.thirdSelectedImageAsset = resultList[0];
          ItemEntryView.isSelectedThirdImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
        if (index == 3) {
          ItemEntryView.fouthSelectedImageAsset = resultList[0];
          ItemEntryView.isSelectedFouthImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
        if (index == 4) {
          ItemEntryView.fifthSelectedImageAsset = resultList[0];
          ItemEntryView.isSelectedFifthImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
        //end single select image

        //for multi select

        if (index == -1 && resultList.length == 1) {
          ItemEntryView.firstSelectedImageAsset = resultList[0];
          ItemEntryView.isSelectedFirstImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
        if (index == -1 && resultList.length == 2) {
          ItemEntryView.firstSelectedImageAsset = resultList[0];
          ItemEntryView.secondSelectedImageAsset = resultList[1];
          ItemEntryView.isSelectedFirstImagePath = true;
          ItemEntryView.isSelectedSecondImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
        if (index == -1 && resultList.length == 3) {
          ItemEntryView.firstSelectedImageAsset = resultList[0];
          ItemEntryView.secondSelectedImageAsset = resultList[1];
          ItemEntryView.thirdSelectedImageAsset = resultList[2];
          ItemEntryView.isSelectedFirstImagePath = true;
          ItemEntryView.isSelectedSecondImagePath = true;
          ItemEntryView.isSelectedThirdImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
        if (index == -1 && resultList.length == 4) {
          ItemEntryView.firstSelectedImageAsset = resultList[0];
          ItemEntryView.secondSelectedImageAsset = resultList[1];
          ItemEntryView.thirdSelectedImageAsset = resultList[2];
          ItemEntryView.fouthSelectedImageAsset = resultList[3];
          ItemEntryView.isSelectedFirstImagePath = true;
          ItemEntryView.isSelectedSecondImagePath = true;
          ItemEntryView.isSelectedThirdImagePath = true;
          ItemEntryView.isSelectedFouthImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
        if (index == -1 && resultList.length == 5) {
          ItemEntryView.firstSelectedImageAsset = resultList[0];
          ItemEntryView.secondSelectedImageAsset = resultList[1];
          ItemEntryView.thirdSelectedImageAsset = resultList[2];
          ItemEntryView.fouthSelectedImageAsset = resultList[3];
          ItemEntryView.fifthSelectedImageAsset = resultList[4];
          ItemEntryView.isSelectedFirstImagePath = true;
          ItemEntryView.isSelectedSecondImagePath = true;
          ItemEntryView.isSelectedThirdImagePath = true;
          ItemEntryView.isSelectedFouthImagePath = true;
          ItemEntryView.isSelectedFifthImagePath = true;
          ++ItemEntryView.numberOfUploadedImages;
        }
      });
    }
  }

  Future<String> uploadToStorage() async {
    String url;
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      var uuid = Uuid();
      final String storageId = (millSeconds.toString() + uuid.v1());
      final String today = ('$month-$date');

      // final file = await ImagePicker.pickVideo(source: ImageSource.gallery);
      final ImagePicker _picker = ImagePicker();
      var  file = await  _picker.pickVideo(source: ImageSource.gallery);


FirebaseStorage storage = FirebaseStorage.instance;
Reference ref = storage.ref().child('video')
          .child(today)
          .child(storageId);
UploadTask uploadTask = ref.putFile(File(file.path), SettableMetadata(contentType: 'video/mp4'));
uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
   }).catchError((onError) {
    print(onError);
    });

      // StorageReference ref = FirebaseStorage.instance
      //     .ref()
      //     .child('video')
      //     .child(today)
      //     .child(storageId);
      // StorageUploadTask uploadTask =
      //     ref.putFile(file, StorageMetadata(contentType: 'video/mp4'));

      // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      // // Waits till the file is uploaded then stores the download url
      // url = await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      print(error);
    }
    return url;
  }

  dynamic updateImagesFromCustomCamera(String imagePath, int index) {
    if (mounted) {
      setState(() {
        //for single select image
        if (index == 0 && imagePath.isNotEmpty) {
          ItemEntryView.firstCameraImagePath = imagePath;
          ItemEntryView.isSelectedFirstImagePath = true;
        }
        if (index == 1 && imagePath.isNotEmpty) {
          ItemEntryView.secondCameraImagePath = imagePath;
          ItemEntryView.isSelectedSecondImagePath = true;
        }
        if (index == 2 && imagePath.isNotEmpty) {
          ItemEntryView.thirdCameraImagePath = imagePath;
          ItemEntryView.isSelectedThirdImagePath = true;
        }
        if (index == 3 && imagePath.isNotEmpty) {
          ItemEntryView.fouthCameraImagePath = imagePath;
          ItemEntryView.isSelectedFouthImagePath = true;
        }
        if (index == 4 && imagePath.isNotEmpty) {
          ItemEntryView.fifthCameraImagePath = imagePath;
          ItemEntryView.isSelectedFifthImagePath = true;
        }
        //end single select image
      });
    }
  }

  LatLng _latlng;
  PsValueHolder valueHolder;
  ItemEntryProvider itemEntryProvider;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    itemEntryProvider = Provider.of<ItemEntryProvider>(context, listen: false);
    _latlng ??= widget.latlng;
    ((widget.flag == PsConst.ADD_NEW_ITEM &&
                widget.locationController.text ==
                    itemEntryProvider.psValueHolder.locactionName) ||
            (widget.flag == PsConst.ADD_NEW_ITEM &&
                widget.locationController.text.isEmpty))
        ? widget.locationController.text =
            itemEntryProvider.psValueHolder.locactionName
        : Container();
    if (itemEntryProvider.item != null && widget.flag == PsConst.EDIT_ITEM) {
      _latlng = LatLng(double.parse(itemEntryProvider.item.lat),
          double.parse(itemEntryProvider.item.lng));
    }

    final Widget _nextStep = Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16,
            bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'Next Step'),
          onPressed: () async {
            if (widget.userInputPlateNumber.text.length == 0) {
              widget.userInputPlateNumber.text = "none";
            }
            ++ItemEntryView.pageNumber;
            setState(() {});
          },
        ));
    final Widget _submit = Row(
      children: [
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                  top: PsDimens.space16,
                  bottom: PsDimens.space48),
              width: double.infinity * 0.2,
              height: PsDimens.space44,
              child: PSButtonWidget(
                hasShadow: true,
                width: double.infinity * 0.2,
                titleText: Utils.getString(context, 'Back'),
                onPressed: () async {
                  if (ItemEntryView.pageNumber >= 2) {
                    _controller.pause();
                  }
                  --ItemEntryView.pageNumber;
                  setState(() {});
                },
              )),
        ),
        //
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                  top: PsDimens.space16,
                  bottom: PsDimens.space48),
              width: double.infinity * 0.2,
              height: PsDimens.space44,
              child: PSButtonWidget(
                hasShadow: true,
                width: double.infinity * 0.2,
                titleText: Utils.getString(context,
                    ItemEntryView.pageNumber >= 2 ? 'Submit' : 'Next Step'),
                onPressed: () async {
                  ++ItemEntryView.pageNumber;
                  setState(() {});
                  //login__submit
                  if (ItemEntryView.pageNumber > 2) {
                    if (ItemEntryView.numberOfUploadedImages == 0) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry_need_image'),
                                onPressed: () {});
                          });
                    } else if (widget.userInputListingTitle.text == null ||
                        widget.userInputListingTitle.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry__need_listing_title'),
                                onPressed: () {});
                          });
                    } else if (widget.manufacturerController.text == null ||
                        widget.manufacturerController.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry__need_manufacturer'),
                                onPressed: () {});
                          });
                    } else if (widget.modelController.text == null ||
                        widget.modelController.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry__need_model'),
                                onPressed: () {});
                          });
                    } else if (widget.userInputPlateNumber.text == null ||
                        widget.userInputPlateNumber.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry__need_plate_number'),
                                onPressed: () {});
                          });
                    } else if (widget.userInputEnginePower.text == null ||
                        widget.userInputEnginePower.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry__need_engine_power'),
                                onPressed: () {});
                          });
                    } else if (widget.transmissionController.text == null ||
                        widget.transmissionController.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry__need_transmission'),
                                onPressed: () {});
                          });
                    } else if (widget.userInputYear.text == null ||
                        widget.userInputYear.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry__need_year'),
                                onPressed: () {});
                          });
                    } else if (widget.typeController.text == null ||
                        widget.typeController.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry_need_type'),
                                onPressed: () {});
                          });
                    } else if (widget.itemConditionController.text == null ||
                        widget.itemConditionController.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry_need_item_condition'),
                                onPressed: () {});
                          });
                    } else if (widget.priceController.text == null ||
                        widget.priceController.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry_need_currency_symbol'),
                                onPressed: () {});
                          });
                    } else if (widget.userInputPrice.text == null ||
                        widget.userInputPrice.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry_need_price'),
                                onPressed: () {});
                          });
                    } else if (widget.userInputDescription.text == null ||
                        widget.userInputDescription.text == '') {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                                message: Utils.getString(
                                    context, 'item_entry_need_description'),
                                onPressed: () {});
                          });
                    } else if (widget.userInputLattitude.text == PsConst.ZERO ||
                        widget.userInputLattitude.text == PsConst.ZERO ||
                        widget.userInputLattitude.text ==
                            PsConst.INVALID_LAT_LNG ||
                        widget.userInputLattitude.text ==
                            PsConst.INVALID_LAT_LNG) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                              message: Utils.getString(
                                  context, 'item_entry_pick_location'),
                              onPressed: () {},
                            );
                          });
                    } else {
                      if (!PsProgressDialog.isShowing()) {
                        await PsProgressDialog.showDialog(context,
                            message: Utils.getString(
                                context, 'progressloading_item_uploading'));
                      }
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        //add new
                        final ItemEntryParameterHolder
                            itemEntryParameterHolder = ItemEntryParameterHolder(
                          manufacturerId: widget.provider.manufacturerId,
                          modelId: widget.provider.modelId,
                          itemTypeId: widget.provider.itemTypeId,
                          itemPriceTypeId: widget.provider.itemPriceTypeId,
                          itemCurrencyId: widget.provider.itemCurrencyId,
                          conditionOfItemId: widget.provider.itemConditionId,
                          itemLocationId: widget.provider.itemLocationId,
                          colorId: widget.provider.itemColorId,
                          fuelTypeId: widget.provider.fuelTypeId,
                          buildTypeId: widget.provider.buildTypeId,
                          sellerTypeId: widget.provider.sellerTypeId,
                          transmissionId: widget.provider.transmissionId,
                          description: widget.userInputDescription.text,
                          highlightInfomation:
                              widget.userInputHighLightInformation.text,
                          price: widget.userInputPrice.text,
                          businessMode: widget.provider.checkOrNotShop,
                          isSoldOut: '',
                          title: widget.userInputListingTitle.text,
                          address: widget.userInputAddress.text,
                          latitude: widget.userInputLattitude.text,
                          longitude: widget.userInputLongitude.text,
                          plateNumber: widget.userInputPlateNumber.text,
                          enginePower: widget.userInputEnginePower.text,
                          steeringPosition:
                              widget.userInputSteeringPosition.text,
                          noOfOwner: widget.userInputNumOfOwner.text,
                          trimName: widget.userInputTrimName.text,
                          vehicleId: widget.userInputVehicleId.text,
                          priceUnit: widget.userInputPriceUnit.text,
                          year: widget.userInputYear.text,
                          // licenceStatus: widget.provider.licenceStatus,
                          maxPassengers: widget.userInputMaximumPassenger.text,
                          noOfDoors: widget.userInputNumOfDoor.text,
                          mileage: widget.userInputMileage.text,
                          licenseEexpirationDate:
                              widget.userInputLicenseExpDate.text,
                          id: widget.provider.itemId,
                          addedUserId:
                              widget.provider.psValueHolder.loginUserId,
                        );

                        final PsResource<Product> itemData = await widget
                            .provider
                            .postItemEntry(itemEntryParameterHolder.toMap());
                        PsProgressDialog.dismissDialog();

                        if (itemData.status == PsStatus.SUCCESS) {
                          Map<String, String> input = new Map();
                          input['id'] = widget.userInputListingTitle.text;
                          input['image'] = urlVideo;
                          
                          // await Firestore.instance
                          await FirebaseFirestore.instance
                              .collection('video')
                              .add(input);
                          widget.provider.itemId = itemData.data.id;
                          widget.uploadImage(itemData.data.id);
                          _controller.dispose();
                          if (itemData.data != null) {
                            if (widget.isSelectedFirstImagePath ||
                                widget.isSelectedSecondImagePath ||
                                widget.isSelectedThirdImagePath ||
                                widget.isSelectedFouthImagePath ||
                                widget.isSelectedFifthImagePath) {}
                          }
                        } else {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                  message: itemData.message,
                                );
                              });
                        }
                      } else {
                        // edit item

                        final ItemEntryParameterHolder
                            itemEntryParameterHolder = ItemEntryParameterHolder(
                          manufacturerId: widget.provider.manufacturerId,
                          modelId: widget.provider.modelId,
                          itemTypeId: widget.provider.itemTypeId,
                          itemPriceTypeId: widget.provider.itemPriceTypeId,
                          itemCurrencyId: widget.provider.itemCurrencyId,
                          conditionOfItemId: widget.provider.itemConditionId,
                          itemLocationId: widget.provider.itemLocationId,
                          colorId: widget.provider.itemColorId,
                          fuelTypeId: widget.provider.fuelTypeId,
                          buildTypeId: widget.provider.buildTypeId,
                          sellerTypeId: widget.provider.sellerTypeId,
                          transmissionId: widget.provider.transmissionId,
                          description: widget.userInputDescription.text,
                          highlightInfomation:
                              widget.userInputHighLightInformation.text,
                          price: widget.userInputPrice.text,
                          businessMode: widget.provider.checkOrNotShop,
                          isSoldOut: widget.item.isSoldOut,
                          title: widget.userInputListingTitle.text,
                          address: widget.userInputAddress.text,
                          latitude: widget.userInputLattitude.text,
                          longitude: widget.userInputLongitude.text,
                          plateNumber: widget.userInputPlateNumber.text,
                          enginePower: widget.userInputEnginePower.text,
                          steeringPosition:
                              widget.userInputSteeringPosition.text,
                          noOfOwner: widget.userInputNumOfOwner.text,
                          trimName: widget.userInputTrimName.text,
                          vehicleId: widget.userInputVehicleId.text,
                          priceUnit: widget.userInputPriceUnit.text,
                          year: widget.userInputYear.text,
                          // licenceStatus: widget.provider.licenceStatus,
                          maxPassengers: widget.userInputMaximumPassenger.text,
                          noOfDoors: widget.userInputNumOfDoor.text,
                          mileage: widget.userInputMileage.text,
                          licenseEexpirationDate:
                              widget.userInputLicenseExpDate.text,
                          id: widget.item.id,
                          addedUserId:
                              widget.provider.psValueHolder.loginUserId,
                        );

                        final PsResource<Product> itemData = await widget
                            .provider
                            .postItemEntry(itemEntryParameterHolder.toMap());

                        PsProgressDialog.dismissDialog();
                        if (itemData.status == PsStatus.SUCCESS) {
                          if (itemData.data != null) {
                            Fluttertoast.showToast(
                                msg: 'Item Uploaded',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white);

                            if (widget.isSelectedFirstImagePath ||
                                widget.isSelectedSecondImagePath ||
                                widget.isSelectedThirdImagePath ||
                                widget.isSelectedFouthImagePath ||
                                widget.isSelectedFifthImagePath) {
                              widget.uploadImage(itemData.data.id);
                            }
                          }
                        } else {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                  message: itemData.message,
                                );
                              });
                        }
                      }
                    }
                  }
                  //
                },
              )),
        )
      ],
    );
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      ItemEntryView.pageNumber < 1
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('much information as possible'),
            )
          : Container(),
      //
      ItemEntryView.pageNumber < 1
          ? Container(
              width: MediaQuery.of(context).size.width,
              color: PsColors.mainColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                child: Text(
                  'Optional Information',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: PsColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            )
          : Container(),
      //First One
      ItemEntryView.pageNumber == 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PsDropdownBaseWithControllerWidget(
                  title: Utils.getString(context, 'item_entry__manufacture'),
                  textEditingController: widget.manufacturerController,
                  isStar: true,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final ItemEntryProvider provider =
                        Provider.of<ItemEntryProvider>(context, listen: false);

                    final dynamic categoryResult = await Navigator.pushNamed(
                        context, RoutePaths.manufacturer,
                        arguments: widget.manufacturerController.text);

                    if (categoryResult != null &&
                        categoryResult is Manufacturer) {
                      provider.manufacturerId = categoryResult.id;
                      widget.manufacturerController.text = categoryResult.name;
                      provider.modelId = '';
                      if (mounted) {
                        setState(() {
                          widget.manufacturerController.text =
                              categoryResult.name;
                          widget.modelController.text = '';
                        });
                      }
                    } else if (categoryResult) {
                      widget.manufacturerController.text = '';
                    }
                  },
                ),
                //
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__model'),
                    textEditingController: widget.modelController,
                    isStar: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final ItemEntryProvider provider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);
                      if (provider.manufacturerId != '') {
                        final dynamic subCategoryResult =
                            await Navigator.pushNamed(
                                context, RoutePaths.searchSubCategory,
                                arguments: ModelIntentHolder(
                                    modelName: widget.modelController.text,
                                    categoryId: provider.manufacturerId));
                        if (subCategoryResult != null &&
                            subCategoryResult is Model) {
                          provider.modelId = subCategoryResult.id;

                          widget.modelController.text = subCategoryResult.name;
                        } else if (subCategoryResult) {
                          widget.modelController.text = '';
                        }
                      } else {
                        showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ErrorDialog(
                                message: Utils.getString(context,
                                    'home_search__choose_manufacturer_first'),
                              );
                            });
                        const ErrorDialog(message: 'Choose Category first');
                      }
                    }),
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__color'),
                    textEditingController: widget.itemColorController,
                    isStar: false,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      final dynamic itemColorResult = await Navigator.pushNamed(
                          context, RoutePaths.itemColor,
                          arguments: widget.itemColorController.text);

                      if (itemColorResult != null &&
                          itemColorResult is ItemColor) {
                        widget.provider.itemColorId = itemColorResult.id;
                        widget.itemColorController.text =
                            itemColorResult.colorValue;
                        if (mounted) {
                          setState(() {
                            widget.itemColorController.text =
                                itemColorResult.colorValue;
                          });
                        }
                      } else if (itemColorResult) {
                        widget.itemColorController.text = '';
                      }
                    }),
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__fuel_type'),
                    textEditingController: widget.itemFuelTypeController,
                    isStar: false,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      final dynamic itemFuelTypeResult =
                          await Navigator.pushNamed(
                              context, RoutePaths.itemFuelType,
                              arguments: widget.itemFuelTypeController.text);

                      if (itemFuelTypeResult != null &&
                          itemFuelTypeResult is ItemFuelType) {
                        widget.provider.fuelTypeId = itemFuelTypeResult.id;
                        widget.itemFuelTypeController.text =
                            itemFuelTypeResult.fuelName;
                        if (mounted) {
                          setState(() {
                            widget.itemFuelTypeController.text =
                                itemFuelTypeResult.fuelName;
                          });
                        }
                      } else if (itemFuelTypeResult) {
                        widget.itemFuelTypeController.text = '';
                      }
                    }),
                //
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__type'),
                    textEditingController: widget.typeController,
                    isStar: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final ItemEntryProvider provider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);

                      final dynamic itemTypeResult = await Navigator.pushNamed(
                          context, RoutePaths.itemType,
                          arguments: widget.typeController.text);

                      if (itemTypeResult != null &&
                          itemTypeResult is ItemType) {
                        provider.itemTypeId = itemTypeResult.id;
                        if (mounted) {
                          setState(() {
                            widget.typeController.text = itemTypeResult.name;
                          });
                        }
                      } else if (itemTypeResult) {
                        widget.typeController.text = '';
                      }
                    }),

                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__transmission'),
                    textEditingController: widget.transmissionController,
                    isStar: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      final dynamic transmissionResult =
                          await Navigator.pushNamed(
                              context, RoutePaths.transmission,
                              arguments: widget.transmissionController.text);

                      if (transmissionResult != null &&
                          transmissionResult is Transmission) {
                        widget.provider.transmissionId = transmissionResult.id;
                        widget.transmissionController.text =
                            transmissionResult.name;
                        if (mounted) {
                          setState(() {
                            widget.transmissionController.text =
                                transmissionResult.name;
                          });
                        }
                      } else if (transmissionResult) {
                        widget.transmissionController.text = '';
                      }
                    }),
//
                PsTextFieldWidget(
                  titleText: Utils.getString(
                      context, 'item_entry__license_expiration_date'),
                  textAboutMe: false,
                  textEditingController: widget.userInputLicenseExpDate,
                  isStar: false,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__year'),
                  textAboutMe: false,
                  textEditingController: widget.userInputYear,
                  isStar: true,
                ),

                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__steering_position'),
                  textAboutMe: false,
                  textEditingController: widget.userInputSteeringPosition,
                  isStar: false,
                ),
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__number_of_owner'),
                  textAboutMe: false,
                  textEditingController: widget.userInputNumOfOwner,
                  isStar: false,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__trim_name'),
                  textAboutMe: false,
                  textEditingController: widget.userInputTrimName,
                  isStar: false,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__vehicle_id'),
                  textAboutMe: false,
                  textEditingController: widget.userInputVehicleId,
                  isStar: false,
                ),
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__build_type'),
                    textEditingController: widget.itemBuildTypeController,
                    isStar: false,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      final dynamic itemBuildTypeResult =
                          await Navigator.pushNamed(
                              context, RoutePaths.itemBuildType,
                              arguments: widget.itemBuildTypeController.text);

                      if (itemBuildTypeResult != null &&
                          itemBuildTypeResult is ItemBuildType) {
                        widget.provider.buildTypeId = itemBuildTypeResult.id;
                        widget.itemBuildTypeController.text =
                            itemBuildTypeResult.carType;
                        if (mounted) {
                          setState(() {
                            widget.itemBuildTypeController.text =
                                itemBuildTypeResult.carType;
                          });
                        }
                      } else if (itemBuildTypeResult) {
                        widget.itemBuildTypeController.text = '';
                      }
                    }),

                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__engine_power'),
                  textAboutMe: false,
                  textEditingController: widget.userInputEnginePower,
                  isStar: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: PsDimens.space12),
                  child: Text(
                      Utils.getString(context, 'item_entry__licence_status'),
                      style: Theme.of(context).textTheme.bodyText2),
                ),
                LicenseCheckbox(
                  provider: widget.provider,
                  onCheckBoxClick: () {
                    if (mounted) {
                      setState(() {
                        updateLicenseCheckBox(context, widget.provider);
                      });
                    }
                  },
                ),
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__maximum_passenger'),
                  textAboutMe: false,
                  textEditingController: widget.userInputMaximumPassenger,
                  isStar: false,
                ),
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__number_of_door'),
                  textAboutMe: false,
                  textEditingController: widget.userInputNumOfDoor,
                  isStar: false,
                ),
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__seller_type'),
                    textEditingController: widget.itemSellerTypeController,
                    isStar: false,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      final dynamic itemSellerTypeResult =
                          await Navigator.pushNamed(
                              context, RoutePaths.itemSellerType,
                              arguments: widget.itemSellerTypeController.text);

                      if (itemSellerTypeResult != null &&
                          itemSellerTypeResult is ItemSellerType) {
                        widget.provider.sellerTypeId = itemSellerTypeResult.id;
                        widget.itemSellerTypeController.text =
                            itemSellerTypeResult.sellerType;
                        if (mounted) {
                          setState(() {
                            widget.itemSellerTypeController.text =
                                itemSellerTypeResult.sellerType;
                          });
                        }
                      } else if (itemSellerTypeResult) {
                        widget.itemSellerTypeController.text = '';
                      }
                    }),
                PsDropdownBaseWithControllerWidget(
                    title:
                        Utils.getString(context, 'item_entry__item_condition'),
                    textEditingController: widget.itemConditionController,
                    isStar: true,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final ItemEntryProvider provider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);

                      final dynamic itemConditionResult =
                          await Navigator.pushNamed(
                              context, RoutePaths.itemCondition,
                              arguments: widget.itemConditionController.text);

                      if (itemConditionResult != null &&
                          itemConditionResult is ConditionOfItem) {
                        provider.itemConditionId = itemConditionResult.id;
                        if (mounted) {
                          setState(() {
                            widget.itemConditionController.text =
                                itemConditionResult.name;
                          });
                        }
                      } else if (itemConditionResult) {
                        widget.itemConditionController.text = '';
                      }
                    }),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__price_unit'),
                  textAboutMe: false,
                  textEditingController: widget.userInputPriceUnit,
                ),
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__price_type'),
                    textEditingController: widget.priceTypeController,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final ItemEntryProvider provider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);

                      final dynamic itemPriceTypeResult =
                          await Navigator.pushNamed(
                              context, RoutePaths.itemPriceType,
                              arguments: widget.priceTypeController.text);

                      if (itemPriceTypeResult != null &&
                          itemPriceTypeResult is ItemPriceType) {
                        provider.itemPriceTypeId = itemPriceTypeResult.id;
                        if (mounted) {
                          setState(() {
                            widget.priceTypeController.text =
                                itemPriceTypeResult.name;
                          });
                        }
                      } else if (itemPriceTypeResult) {
                        widget.priceTypeController.text = '';
                      }
                    }),
                PriceDropDownControllerWidget(
                    currencySymbolController: widget.priceController,
                    userInputPriceController: widget.userInputPrice),
                const SizedBox(height: PsDimens.space8),
                /* Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: PsDimens.space12),
                      child: Text(
                          Utils.getString(context, 'item_entry__for_free_item'),
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                    const SizedBox(height: PsDimens.space8),
                    Padding(
                      padding: const EdgeInsets.only(left: PsDimens.space12),
                      child: Text(
                          Utils.getString(context, 'item_entry__shop_setting'),
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                    BusinessModeCheckbox(
                      provider: widget.provider,
                      onCheckBoxClick: () {
                        if (mounted) {
                          setState(() {
                            updateCheckBox(context, widget.provider);
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: PsDimens.space40),
                      child: Text(
                          Utils.getString(
                              context, 'item_entry__show_more_than_one'),
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ],
                ),*/
                /*  PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__highlight_info'),
                  height: PsDimens.space120,
                  hintText:
                      Utils.getString(context, 'item_entry__highlight_info'),
                  textAboutMe: true,
                  textEditingController: widget.userInputHighLightInformation,
                ),*/
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__description'),
                  height: PsDimens.space120,
                  hintText: Utils.getString(context, 'item_entry__description'),
                  textAboutMe: true,
                  textEditingController: widget.userInputDescription,
                  isStar: true,
                ),
                PsDropdownBaseWithControllerWidget(
                    title: Utils.getString(context, 'item_entry__location'),
                    textEditingController: widget.locationController,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final ItemEntryProvider provider =
                          Provider.of<ItemEntryProvider>(context,
                              listen: false);

                      final dynamic itemLocationResult =
                          await Navigator.pushNamed(
                              context, RoutePaths.itemLocation,
                              arguments: widget.locationController.text);

                      if (itemLocationResult != null &&
                          itemLocationResult is ItemLocation) {
                        provider.itemLocationId = itemLocationResult.id;
                        if (mounted) {
                          setState(() {
                            widget.locationController.text =
                                itemLocationResult.name;
                            _latlng = LatLng(
                                double.parse(itemLocationResult.lat),
                                double.parse(itemLocationResult.lng));

                            widget.mapController.move(_latlng, widget.zoom);

                            widget.userInputLattitude.text =
                                itemLocationResult.lat;
                            widget.userInputLongitude.text =
                                itemLocationResult.lng;

                            widget.userInputAddress.text = '';
                          });
                        }
                      }
                    }),

                /* PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__latitude'),
                  textAboutMe: false,
                  textEditingController: widget.userInputLattitude,
                ),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__longitude'),
                  textAboutMe: false,
                  textEditingController: widget.userInputLongitude,
                ),*/
                //////////////////////////////////////////////////////////////////

                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'item_entry__mileage'),
                  textAboutMe: false,
                  textEditingController: widget.userInputMileage,
                  isStar: false,
                ),
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'item_entry__plate_number'),
                  textAboutMe: false,
                  textEditingController: widget.userInputPlateNumber,
                  isStar: false,
                ),
              ],
            )
          : ItemEntryView.pageNumber == 1
              ? Column(
                  children: [
                    PsTextFieldWidget(
                      titleText:
                          Utils.getString(context, 'item_entry__address'),
                      textAboutMe: false,
                      //height: PsDimens.space160,
                      textEditingController: widget.userInputAddress,
                      hintText: Utils.getString(context, 'item_entry__address'),
                    ),
                    PsDropdownBaseWithControllerWidget(
                        title: Utils.getString(context, 'item_entry__location'),
                        textEditingController: widget.locationController,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final ItemEntryProvider provider =
                              Provider.of<ItemEntryProvider>(context,
                                  listen: false);

                          final dynamic itemLocationResult =
                              await Navigator.pushNamed(
                                  context, RoutePaths.itemLocation,
                                  arguments: widget.locationController.text);

                          if (itemLocationResult != null &&
                              itemLocationResult is ItemLocation) {
                            provider.itemLocationId = itemLocationResult.id;
                            if (mounted) {
                              setState(() {
                                widget.locationController.text =
                                    itemLocationResult.name;
                                _latlng = LatLng(
                                    double.parse(itemLocationResult.lat),
                                    double.parse(itemLocationResult.lng));

                                widget.mapController.move(_latlng, widget.zoom);

                                widget.userInputLattitude.text =
                                    itemLocationResult.lat;
                                widget.userInputLongitude.text =
                                    itemLocationResult.lng;

                                widget.userInputAddress.text = '';
                              });
                            }
                          }
                        }),
                    CurrentLocationWidget(
                      androidFusedLocation: true,
                      textEditingController: widget.userInputAddress,
                      latController: widget.userInputLattitude,
                      lngController: widget.userInputLongitude,
                      valueHolder: valueHolder,
                      updateLatLng: (Position currentPosition) {
                        if (currentPosition != null) {
                          setState(() {
                            _latlng = LatLng(currentPosition.latitude,
                                currentPosition.longitude);
                            widget.mapController.move(_latlng, widget.zoom);
                          });
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: Container(
                        height: 250,
                        child: FlutterMap( 
                          mapController: widget.mapController,
                          options: MapOptions(
                              center:
                                  _latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                              zoom: widget.zoom, //10.0,
                               onTap: _handleTap
                              // onTap: (LatLng latLngr) {
                                
                              //   FocusScope.of(context)
                              //       .requestFocus(FocusNode());
                              //   _handleTap(_latlng, widget.mapController);
                              // }
                              ),
                          layers: <LayerOptions>[
                            TileLayerOptions(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            ),
                            MarkerLayerOptions(markers: <Marker>[
                              Marker(
                                width: 80.0, 
                                height: 80.0,
                                point: _latlng,
                                builder: (BuildContext ctx) => Container(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.location_on,
                                      color: PsColors.mainColor,
                                    ),
                                    iconSize: 45,
                                    onPressed: () {},
                                  ),
                                ),
                              )
                            ])
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: PsDimens.space16,
                          left: PsDimens.space10,
                          right: PsDimens.space10),
                      child: Text(
                        Utils.getString(context,
                            'Improve the performance of your listing by adding pictures of the item for FREE. The most engaging videos are between 15-20 seconds long.'),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(height: 1.3, fontSize: 15.0),
                      ),
                    ),
                    //
                    ItemEntryView.pageNumber >= 2
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PsTextFieldWidget(
                                titleText: Utils.getString(
                                    context, 'item_entry__listing_title'),
                                textAboutMe: false,
                                hintText: Utils.getString(
                                    context, 'item_entry__entry_title'),
                                textEditingController:
                                    widget.userInputListingTitle,
                                isStar: true,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: PsDimens.space16,
                                    left: PsDimens.space10,
                                    right: PsDimens.space10,
                                    bottom: PsDimens.space10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                          Utils.getString(context,
                                              'item_entry__choose_photo_showcase'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2),
                                    ),
                                    Text(' *',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                color: PsColors.mainColor))
                                  ],
                                ),
                              ),

                              //  _largeSpacingWidget,
                              Consumer<GalleryProvider>(builder:
                                  (BuildContext context,
                                      GalleryProvider provider, Widget child) {
                                if (provider != null &&
                                    provider.galleryList.data.isNotEmpty) {
                                  for (int imageId = 0;
                                      imageId <
                                          provider.galleryList.data.length;
                                      imageId++) {
                                    if (imageId == 0) {
                                      itemEntryProvider.firstImageId = provider
                                          .galleryList.data[imageId].imgId;
                                    }
                                    if (imageId == 1) {
                                      itemEntryProvider.secondImageId = provider
                                          .galleryList.data[imageId].imgId;
                                    }
                                    if (imageId == 2) {
                                      itemEntryProvider.thirdImageId = provider
                                          .galleryList.data[imageId].imgId;
                                    }
                                    if (imageId == 3) {
                                      itemEntryProvider.fourthImageId = provider
                                          .galleryList.data[imageId].imgId;
                                    }
                                    if (imageId == 4) {
                                      itemEntryProvider.fiveImageId = provider
                                          .galleryList.data[imageId].imgId;
                                    }
                                  }
                                }

                                return ImageUploadHorizontalList(
                                  flag: widget.flag,
                                  images: ItemEntryView.images,
                                  selectedImageList: ItemEntryView
                                      .galleryProvider.selectedImageList,
                                  updateImages: updateImages,
                                  updateImagesFromCustomCamera:
                                      updateImagesFromCustomCamera,
                                  firstImagePath:
                                      ItemEntryView.firstSelectedImageAsset,
                                  secondImagePath:
                                      ItemEntryView.secondSelectedImageAsset,
                                  thirdImagePath:
                                      ItemEntryView.thirdSelectedImageAsset,
                                  fouthImagePath:
                                      ItemEntryView.fouthSelectedImageAsset,
                                  fifthImagePath:
                                      ItemEntryView.fifthSelectedImageAsset,
                                  firstCameraImagePath:
                                      ItemEntryView.firstCameraImagePath,
                                  secondCameraImagePath:
                                      ItemEntryView.secondCameraImagePath,
                                  thirdCameraImagePath:
                                      ItemEntryView.thirdCameraImagePath,
                                  fouthCameraImagePath:
                                      ItemEntryView.fouthCameraImagePath,
                                  fifthCameraImagePath:
                                      ItemEntryView.fifthCameraImagePath,
                                );
                              }),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Text('Upload Video *'),
                              ),
                              loading == false && urlVideo == null
                                  ? InkWell(
                                      onTap: () async {
                                        loading = true;
                                        setState(() {});
                                        //
                                        urlVideo = await uploadToStorage();
                                        print(urlVideo);
                                        _controller =
                                            VideoPlayerController.network(
                                          urlVideo,
                                          videoPlayerOptions:
                                              VideoPlayerOptions(
                                                  mixWithOthers: true),
                                        );

                                        _controller.addListener(() {
                                          setState(() {});
                                        });
                                        _controller.setLooping(true);
                                        _controller.initialize();
                                        //
                                        loading = false;
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/movie.png",
                                              width: 50,
                                              height: 50,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Add(+20 seconds) video',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.0),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : loading == false && urlVideo != null
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          height: 200,
                                          padding: const EdgeInsets.all(12),
                                          child: AspectRatio(
                                            aspectRatio:
                                                _controller.value.aspectRatio,
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: <Widget>[
                                                VideoPlayer(_controller),
                                                _ControlsOverlay(
                                                  controller: _controller,
                                                ),
                                                ClosedCaption(
                                                    text: _controller
                                                        .value.caption.text),
                                                VideoProgressIndicator(
                                                    _controller,
                                                    allowScrubbing: true),
                                              ],
                                            ),
                                          ))
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 12),
                                          child: CircularProgressIndicator(),
                                        )
                            ],
                          )
                        : Container(),
                  ],
                ),
      ItemEntryView.pageNumber == 0 ? _nextStep : _submit
      ////////////////////////////////////////////////////////////////////////////////////
    ]);
  }

  Widget header(String key) {
    return Padding(
      padding: const EdgeInsets.only(
          top: PsDimens.space16,
          left: PsDimens.space12,
          right: PsDimens.space12),
      child: Text(Utils.getString(context, key),
          style: Theme.of(context).textTheme.bodyText2),
    );
  }

  Widget shape(String key, bool selected) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40.0,
        decoration: BoxDecoration(
            color: selected ? PsColors.mainColor : Colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            key,
            style: TextStyle(
                fontSize: 14,
                color: selected ? Colors.white : PsColors.mainColor),
          ),
        ),
      ),
    );
  }

  void _handleTap(LatLng latLng, ) async {
    MapController mapController = widget.mapController;
    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng.latitude.toString(),
            mapLng: _latlng.longitude.toString()));
    if (result != null && result is MapPinCallBackHolder) {
      if (mounted) {
        setState(() {
          // _latlng = result.latLng;
          mapController.move(_latlng, widget.zoom);
          widget.userInputAddress.text = result.address;
          // tappedPoints = <LatLng>[];
          // tappedPoints.add(latlng);
        });
      }
      widget.userInputLattitude.text = result.latLng.latitude.toString();
      widget.userInputLongitude.text = result.latLng.longitude.toString();
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
class ImageUploadHorizontalList extends StatefulWidget {
  const ImageUploadHorizontalList(
      {@required this.flag,
      @required this.images,
      @required this.selectedImageList,
      @required this.updateImages,
      @required this.updateImagesFromCustomCamera,
      @required this.firstImagePath,
      @required this.secondImagePath,
      @required this.thirdImagePath,
      @required this.fouthImagePath,
      @required this.fifthImagePath,
      @required this.firstCameraImagePath,
      @required this.secondCameraImagePath,
      @required this.thirdCameraImagePath,
      @required this.fouthCameraImagePath,
      @required this.fifthCameraImagePath});
  final String flag;
  final List<Asset> images;
  final List<DefaultPhoto> selectedImageList;
  final Function updateImages;
  final Function updateImagesFromCustomCamera;
  final Asset firstImagePath;
  final Asset secondImagePath;
  final Asset thirdImagePath;
  final Asset fouthImagePath;
  final Asset fifthImagePath;
  final String firstCameraImagePath;
  final String secondCameraImagePath;
  final String thirdCameraImagePath;
  final String fouthCameraImagePath;
  final String fifthCameraImagePath;
  @override
  State<StatefulWidget> createState() {
    return ImageUploadHorizontalListState();
  }
}

class ImageUploadHorizontalListState extends State<ImageUploadHorizontalList> {
  ItemEntryProvider provider;
  Future<void> loadPickMultiImage() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        // selectedAssets: null, //widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].name.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
        return;
      }
    }
    widget.updateImages(resultList, -1);
  }

  Future<void> loadSingleImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].name.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
        return;
      } else {
        widget.updateImages(resultList, index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Asset defaultAssetImage;
    DefaultPhoto defaultUrlImage;
    provider = Provider.of<ItemEntryProvider>(context, listen: false);

    return Container(
      height: PsDimens.space120,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                ItemEntryImageWidget(
                  index: 0,
                  images: (widget.firstImagePath != null)
                      ? widget.firstImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.firstCameraImagePath != null)
                      ? widget.firstCameraImagePath
                      : defaultAssetImage,
                  selectedImage: (widget.selectedImageList.isNotEmpty &&
                          widget.firstImagePath == null &&
                          widget.firstCameraImagePath == null)
                      ? widget.selectedImageList[0]
                      : null,
                  // (widget.firstImagePath != null) ? null : defaultUrlImage,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 0);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(0);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(0);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 1,
                  images: (widget.secondImagePath != null)
                      ? widget.secondImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.secondCameraImagePath != null)
                      ? widget.secondCameraImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.secondImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 1 &&
                              widget.secondImagePath == null &&
                              widget.secondCameraImagePath == null)
                          ? widget.selectedImageList[1]
                          : null,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 1);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(1);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(1);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 2,
                  images: (widget.thirdImagePath != null)
                      ? widget.thirdImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.thirdCameraImagePath != null)
                      ? widget.thirdCameraImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.thirdImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 2 &&
                              widget.thirdImagePath == null &&
                              widget.thirdCameraImagePath == null)
                          ? widget.selectedImageList[2]
                          : defaultUrlImage,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 2);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(2);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(2);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 3,
                  images: (widget.fouthImagePath != null)
                      ? widget.fouthImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.fouthCameraImagePath != null)
                      ? widget.fouthCameraImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.fouthImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 3 &&
                              widget.fouthImagePath == null &&
                              widget.fouthCameraImagePath == null)
                          ? widget.selectedImageList[3]
                          : defaultUrlImage,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 3);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(3);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(3);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 4,
                  images: (widget.fifthImagePath != null)
                      ? widget.fifthImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.fifthCameraImagePath != null)
                      ? widget.fifthCameraImagePath
                      : defaultAssetImage,
                  selectedImage: //widget.fifthImagePath != null ||
                      //     widget.selectedImageList.length - 1 >= 4)
                      // ? widget.selectedImageList[4]
                      // : defaultUrlImage,
                      (widget.selectedImageList.length > 4 &&
                              widget.fifthImagePath == null &&
                              widget.fifthCameraImagePath == null)
                          ? widget.selectedImageList[4]
                          : null,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 4);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(4);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(4);
                      }
                    }
                  },
                ),
              ],
            );
          }),
    );
  }
}

class ItemEntryImageWidget extends StatefulWidget {
  const ItemEntryImageWidget({
    Key key,
    @required this.index,
    @required this.images,
    @required this.cameraImagePath,
    @required this.selectedImage,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final int index;
  final Asset images;
  final String cameraImagePath;
  final DefaultPhoto selectedImage;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryImageWidgetState();
  }
}

class ItemEntryImageWidgetState extends State<ItemEntryImageWidget> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.selectedImage != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            width: 100,
            height: 100,
            child: PsNetworkImageWithUrl(
              photoKey: '',
              // width: 100,
              // height: 100,
              imagePath: widget.selectedImage.imgPath,
            ),
          ),
        ),
      );
    } else {
      if (widget.images != null) {
        final Asset asset = widget.images;
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
            onTap: widget.onTap,
            child: AssetThumb(
              asset: asset,
              width: 100,
              height: 100,
            ),
          ),
        );
      } else if (widget.cameraImagePath != null) {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
              onTap: widget.onTap,
              child: Image(
                  width: 100,
                  height: 100,
                  image: FileImage(File(widget.cameraImagePath)))),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
            onTap: widget.onTap,
            child: Image.asset(
              'assets/images/default_image.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
  }
}

class PriceDropDownControllerWidget extends StatelessWidget {
  const PriceDropDownControllerWidget(
      {Key key,
      // @required this.onTap,
      this.currencySymbolController,
      this.userInputPriceController})
      : super(key: key);

  final TextEditingController currencySymbolController;
  final TextEditingController userInputPriceController;
  // final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space4,
              right: PsDimens.space12,
              left: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                Utils.getString(context, 'item_entry__price'),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(' *',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: PsColors.mainColor))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final ItemEntryProvider provider =
                    Provider.of<ItemEntryProvider>(context, listen: false);

                final dynamic itemCurrencySymbolResult =
                    await Navigator.pushNamed(
                        context, RoutePaths.itemCurrencySymbol,
                        arguments: currencySymbolController.text);

                if (itemCurrencySymbolResult != null &&
                    itemCurrencySymbolResult is ItemCurrency) {
                  provider.itemCurrencyId = itemCurrencySymbolResult.id;

                  currencySymbolController.text =
                      itemCurrencySymbolResult.currencySymbol;
                } else if (itemCurrencySymbolResult) {
                  currencySymbolController.text = '';
                }
              },
              child: Container(
                // width: PsDimens.space140,
                height: PsDimens.space44,
                margin: const EdgeInsets.all(PsDimens.space12),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]
                          : Colors.black87),
                ),
                child: Container(
                  margin: const EdgeInsets.all(PsDimens.space12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Ink(
                          color: PsColors.backgroundColor,
                          child: Text(
                            currencySymbolController.text == ''
                                ? Utils.getString(
                                    context, 'home_search__not_set')
                                : currencySymbolController.text,
                            style: currencySymbolController.text == ''
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.grey[600])
                                : Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: PsDimens.space44,
                // margin: const EdgeInsets.only(
                //     top: 24),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]
                          : Colors.black87),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  controller: userInputPriceController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: PsDimens.space12, bottom: PsDimens.space4),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: PsDimens.space8),
          ],
        ),
      ],
    );
  }
}

class LicenseCheckbox extends StatefulWidget {
  const LicenseCheckbox(
      {@required this.provider, @required this.onCheckBoxClick});

  // final String checkOrNot;
  final ItemEntryProvider provider;
  final Function onCheckBoxClick;
  @override
  _LicenseCheckboxState createState() => _LicenseCheckboxState();
}

class _LicenseCheckboxState extends State<LicenseCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider.isLicenseCheckBoxSelect,
            onChanged: (bool value) {
              widget.onCheckBoxClick();
            },
          ),
        ),
        Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_lince'),
                style: Theme.of(context).textTheme.bodyText1),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onCheckBoxClick();
            },
          ),
        ),
      ],
    );
  }
}

void updateLicenseCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isLicenseCheckBoxSelect) {
    provider.isLicenseCheckBoxSelect = false;
    provider.checkOrNotLicense = '0';
  } else {
    provider.isLicenseCheckBoxSelect = true;
    provider.checkOrNotLicense = '1';
    // Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class BusinessModeCheckbox extends StatefulWidget {
  const BusinessModeCheckbox(
      {@required this.provider, @required this.onCheckBoxClick});

  // final String checkOrNot;
  final ItemEntryProvider provider;
  final Function onCheckBoxClick;

  @override
  _BusinessModeCheckbox createState() => _BusinessModeCheckbox();
}

class _BusinessModeCheckbox extends State<BusinessModeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider.isCheckBoxSelect,
            onChanged: (bool value) {
              widget.onCheckBoxClick();
            },
          ),
        ),
        Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_shop'),
                style: Theme.of(context).textTheme.bodyText1),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onCheckBoxClick();
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
    provider.checkOrNotShop = '0';
  } else {
    provider.isCheckBoxSelect = true;
    provider.checkOrNotShop = '1';
    // Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({
    Key key,

    /// If set, enable the FusedLocationProvider on Android
    @required this.androidFusedLocation,
    @required this.textEditingController,
    @required this.latController,
    @required this.lngController,
    @required this.valueHolder,
    @required this.updateLatLng,
  }) : super(key: key);

  final bool androidFusedLocation;
  final TextEditingController textEditingController;
  final TextEditingController latController;
  final TextEditingController lngController;
  final PsValueHolder valueHolder;
  final Function updateLatLng;

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<CurrentLocationWidget> {
  String address = '';
  Position _currentPosition;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();

    _initCurrentLocation();
  }

  dynamic loadAddress() async {
    if (_currentPosition != null) {
      final List<Address> addresses = await Geocoder.local
          .findAddressesFromCoordinates(Coordinates(
              _currentPosition.latitude, _currentPosition.longitude));
      final Address first = addresses.first;
      address = '${first.addressLine}, ${first.countryName}';
      setState(() {
        widget.textEditingController.text = address;
        widget.latController.text = _currentPosition.latitude.toString();
        widget.lngController.text = _currentPosition.longitude.toString();
        widget.updateLatLng(_currentPosition);
      });
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  dynamic _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = !widget.androidFusedLocation
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).then((Position position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      }).catchError((Object e) {
        //
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (_currentPosition == null) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(context, 'map_pin__open_gps'),
                      onPressed: () {},
                    );
                  });
            } else {
              loadAddress();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space8,
                bottom: PsDimens.space8),
            child: Card(
              shape: const BeveledRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              color: PsColors.baseLightColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: PsDimens.space32,
                        width: PsDimens.space32,
                        child: Icon(
                          Icons.gps_fixed,
                          color: PsColors.mainColor,
                          size: PsDimens.space20,
                        ),
                      ),
                      onTap: () {
                        if (_currentPosition == null) {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return WarningDialog(
                                  message: Utils.getString(
                                      context, 'map_pin__open_gps'),
                                  onPressed: () {},
                                );
                              });
                        } else {
                          loadAddress();
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        Utils.getString(context, 'item_entry_pick_location'),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            letterSpacing: 0.8, fontSize: 16, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [1.0];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: 1,
            tooltip: 'Playback speed',
            onSelected: (speed) {},
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: const Text('${1}x'),
            ),
          ),
        ),
      ],
    );
  }
}
