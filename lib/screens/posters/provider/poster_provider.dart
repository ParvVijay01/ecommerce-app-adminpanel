import 'dart:developer';
import 'dart:io';
import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';

import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/category.dart';
import '../../../models/poster.dart';

class PosterProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addPosterFormKey = GlobalKey<FormState>();
  TextEditingController posterNameCtrl = TextEditingController();
  Poster? posterForUpdate;


  File? selectedImage;
  XFile? imgXFile;


  PosterProvider(this._dataProvider);

  addPoster() async {
    try{
      if(selectedImage == null){
        SnackBarHelper.showErrorSnackBar("Please select an image!");
        return;
      }
      Map<String, dynamic> formDataMap = {
        'posterName': posterNameCtrl.text,
        'image': 'no_data',
      };

      final FormData form = await createFormData(imgXFile: imgXFile, formData: formDataMap);

      final response = await service.addItem(endpointUrl: 'posters', itemData: form);
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar("${apiResponse.message}");
          log("Poster added");
          _dataProvider.getAllPosters();
        } else{
          SnackBarHelper.showErrorSnackBar("Failed to add poster: ${apiResponse.message}");
        }
      } else {
        SnackBarHelper.showErrorSnackBar("Error ${response.body?['message'] ?? response.statusText}");
      }
    } catch(err){
      print(err);
      SnackBarHelper.showErrorSnackBar('An error occurred: $err');
      rethrow;
    }
  }

  updatePoster() async {
    try{

      Map<String, dynamic> formDataMap = {
        'posterName': posterNameCtrl.text,
        'image': posterForUpdate?.imageUrl ?? '',
      };

      final FormData form = await createFormData(imgXFile: imgXFile, formData: formDataMap);

      final response = await service.updateItem(endpointUrl: 'posters', itemData: form, itemId: posterForUpdate?.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          clearFields();
          SnackBarHelper.showSuccessSnackBar("${apiResponse.message}");
          log("Poster added");
          _dataProvider.getAllPosters();
        } else{
          SnackBarHelper.showErrorSnackBar("Failed to add poster: ${apiResponse.message}");
        }
      } else {
        SnackBarHelper.showErrorSnackBar("Error ${response.body?['message'] ?? response.statusText}");
      }
    } catch(err){
      print(err);
      SnackBarHelper.showErrorSnackBar('An error occurred: $err');
      rethrow;
    }
  }


  submitPoster(){
    if (posterForUpdate != null) {
      updatePoster();
    } else {
      addPoster();
    }
  }


  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      imgXFile = image;
      notifyListeners();
    }
  }


  deletePoster(Poster poster) async {
    try{
      Response response = await service.deleteItem(endpointUrl: 'posters', itemId: poster.sId ?? '');
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          SnackBarHelper.showSuccessSnackBar('Poster deleted successfully');
          _dataProvider.getAllPosters();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(('Error ${response.body?['message'] ?? response.statusText}'));
      }
    } catch (err){
      print(err);
      rethrow;
    }
  }


  setDataForUpdatePoster(Poster? poster) {
    if (poster != null) {
      clearFields();
      posterForUpdate = poster;
      posterNameCtrl.text = poster.posterName ?? '';
    } else {
      clearFields();
    }
  }

  Future<FormData> createFormData({required XFile? imgXFile, required Map<String, dynamic> formData}) async {
    if (imgXFile != null) {
      MultipartFile multipartFile;
      if (kIsWeb) {
        String fileName = imgXFile.name;
        Uint8List byteImg = await imgXFile.readAsBytes();
        multipartFile = MultipartFile(byteImg, filename: fileName);
      } else {
        String fileName = imgXFile.path.split('/').last;
        multipartFile = MultipartFile(imgXFile.path, filename: fileName);
      }
      formData['img'] = multipartFile;
    }
    final FormData form = FormData(formData);
    return form;
  }

  clearFields() {
    posterNameCtrl.clear();
    selectedImage = null;
    imgXFile = null;
    posterForUpdate = null;
  }
}
