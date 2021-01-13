package com.upsw20201026.scale_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL = "sample/ble"
        const val REQUEST_CODE = 100
    }

    lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        this.channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
            setMethodCallHandler { call: MethodCall?, result: MethodChannel.Result? ->
                when (call?.method) {
                    "toPlatformScreen" -> {
                        val gender = call.argument<String>("gender")
                        val age = call.argument<String>("age")
                        val height = call.argument<String>("height")
                        startActivityForResult(NextActivity.intent(this@MainActivity).apply {
                            putExtra("gender", gender)
                            putExtra("age", age)
                            putExtra("height", height)
                        }, REQUEST_CODE)
                    }
                    else -> result?.notImplemented()
                }
            }
        }
    }
    
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            REQUEST_CODE -> {
                channel.invokeMethod("onClosed", mapOf(
                        "status" to data!!.getStringExtra("status"),
                        "weight" to data!!.getStringExtra("weight"),
                        "BMI" to data!!.getStringExtra("BMI"),
                        "BodyfatPercentage" to data!!.getStringExtra("BodyfatPercentage"),
                        "MuscleKg" to data!!.getStringExtra("MuscleKg"),
                        "WaterPercentage" to data!!.getStringExtra("WaterPercentage"),
                        "VFAL" to data!!.getStringExtra("VFAL"),
                        "BoneKg" to data!!.getStringExtra("BoneKg"),
                        "BMR" to data!!.getStringExtra("BMR"),
                        "ProteinPercentage" to data!!.getStringExtra("ProteinPercentage"),
                        "VFPercentage" to data!!.getStringExtra("VFPercentage"),
                        "LoseFatWeightKg" to data!!.getStringExtra("LoseFatWeightKg"),
                        "Bodystandard" to data!!.getStringExtra("Bodystandard")
                ))
            }
        }
    }
}

//class MainActivity: FlutterActivity() {
//    private val CHANNEL = "sample/ble"
//    var bleManager: BleManager? = null
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//            // Note: this method is invoked on the main thread.
//            call, result ->
//            if (call.method == "binding") {
//                
////                val data = binding()
//
////                if (data["weight"] != 0.0) {
////                    result.success(data)
////                } else {
////                    result.error("UNAVAILABLE", "bleDevice not available", null)
////                } 
////                val weight = binding()
////                if (weight != "") {
////                    result.success(weight)
////                } else {
////                    result.error("UNAVAILABLE", "bleDevice not available", null)
////                }
//    
//                bleManager = BleManager.shareInstance(application)
//                val deviceList: List<BleDeviceModel> = ArrayList()
//                val userModel: BleUserModel = BleUserModel(180, 18, BleEnum.BleSex.Male, BleEnum.BleUnit.BLE_UNIT_KG, 0)
//                bleManager!!.searchDevice(true, deviceList, userModel, object : BleDataProtocoInterface {
//                    override fun progressData(bodyDataModel: LFPeopleGeneral) {
////                data["weight"] = bodyDataModel.lfWeightKg
////                data["BMI"] = bodyDataModel.lfBMI
////                data["BodyfatPercentage"] = bodyDataModel.lfBodyfatPercentage
//                        val data = bodyDataModel.lfWeightKg.toString()
//                        result.success(data)
//                    }
//
//                    override fun lockedData(bodyDataModel: LFPeopleGeneral, deviceModel: BleDeviceModel, isHeartRating: Boolean) {
//                        val data = bodyDataModel.lfWeightKg.toString()
//                        result.success(data)
//                    }
//                    override fun historyData(isEnd: Boolean, bodyDataModel: LFPeopleGeneral, date: String) {}
//                    override fun deviceInfo(deviceModel: BleDeviceModel) {}
//                })
//            } else if(call.method == "stop"){
//                stop()
//            }else{
//                result.notImplemented()
//            }
//        }
//    }
//
////    private fun binding(): MutableMap<String, Double> {
////        val data = mutableMapOf(
////                "weight" to 0.0,
////                "BMI" to 0.0,
////                "BodyfatPercentage" to 0.0
////        )
////        
////        bleManager = BleManager.shareInstance(application)
////        val deviceList: List<BleDeviceModel> = ArrayList()
////        val userModel: BleUserModel = BleUserModel(180, 18, BleEnum.BleSex.Male, BleEnum.BleUnit.BLE_UNIT_KG, 0)
////        bleManager!!.searchDevice(true, deviceList, userModel, object : BleDataProtocoInterface {
////            override fun progressData(bodyDataModel: LFPeopleGeneral) {
////                weight = bodyDataModel.lfWeightKg.toString()
////                data["weight"] = bodyDataModel.lfWeightKg
////                data["BMI"] = bodyDataModel.lfBMI
////                data["BodyfatPercentage"] = bodyDataModel.lfBodyfatPercentage
////            }
////
////            override fun lockedData(bodyDataModel: LFPeopleGeneral, deviceModel: BleDeviceModel, isHeartRating: Boolean) {}
////            override fun historyData(isEnd: Boolean, bodyDataModel: LFPeopleGeneral, date: String) {}
////            override fun deviceInfo(deviceModel: BleDeviceModel) {}
////        })
////
////        return data
////    }
//
//    private fun binding(): String {
////        val data = mutableMapOf(
////                "weight" to 0.0,
////                "BMI" to 0.0,
////                "BodyfatPercentage" to 0.0
////        )
//        var data = ""
//        bleManager = BleManager.shareInstance(application)
//        val deviceList: List<BleDeviceModel> = ArrayList()
//        val userModel: BleUserModel = BleUserModel(180, 18, BleEnum.BleSex.Male, BleEnum.BleUnit.BLE_UNIT_KG, 0)
//        bleManager!!.searchDevice(true, deviceList, userModel, object : BleDataProtocoInterface {
//            override fun progressData(bodyDataModel: LFPeopleGeneral) {
////                data["weight"] = bodyDataModel.lfWeightKg
////                data["BMI"] = bodyDataModel.lfBMI
////                data["BodyfatPercentage"] = bodyDataModel.lfBodyfatPercentage
//            }
//
//            override fun lockedData(bodyDataModel: LFPeopleGeneral, deviceModel: BleDeviceModel, isHeartRating: Boolean) {
//                data = bodyDataModel.lfWeightKg.toString()
//            }
//            override fun historyData(isEnd: Boolean, bodyDataModel: LFPeopleGeneral, date: String) {}
//            override fun deviceInfo(deviceModel: BleDeviceModel) {}
//        })
//        return data
//    }
//
//    private fun stop() {
//        bleManager!!.stopSearch()
//    }
//}
