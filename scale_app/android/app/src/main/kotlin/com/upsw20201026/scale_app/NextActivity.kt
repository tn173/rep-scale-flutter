package com.upsw20201026.scale_app

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import com.peng.ppscale.business.ble.BleOptions
import com.peng.ppscale.business.ble.PPScale
import com.peng.ppscale.business.ble.listener.PPBleStateInterface
import com.peng.ppscale.business.ble.listener.ProtocalFilterImpl
import com.peng.ppscale.business.device.PPUnitType
import com.peng.ppscale.business.state.PPBleSwitchState
import com.peng.ppscale.business.state.PPBleWorkState
import com.peng.ppscale.util.Logger
import com.peng.ppscale.vo.PPUserModel
import com.peng.ppscale.vo.PPUserSex


class NextActivity : AppCompatActivity() {

    var weightTextView: TextView? = null
    var statusTextView: TextView? = null
    var ppScale: PPScale? = null
    var unitType: PPUnitType? = null
    var userModel: PPUserModel? = null

    companion object {
        fun intent(context: Context) = Intent(context, NextActivity::class.java).apply {}
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_next)

        val toolbar = findViewById<Toolbar>(R.id.toolbar)

        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener {
            this@NextActivity.setResult(Activity.RESULT_OK, intent)
            this@NextActivity.finish()
        }
        intent.apply {
            putExtra("status", "fail")
        }
        supportActionBar?.title = "体重測定"

        statusTextView = findViewById(R.id.status)
        statusTextView!!.setText("測定中")
        weightTextView = findViewById(R.id.weight)
        
        val ageInput = intent.extras!!["age"] as String // 10-99
        val age = "年齢: " + ageInput + "歳"
        val heightInput = intent.extras!!["height"] as String // 100-220cm
        val height = "身長: " + heightInput + "cm"
        val genderTextInput = intent.extras!!["gender"] as String
        val genderText = "性別: " + genderTextInput
        val gender = if (intent.extras!!["gender"] as String == "男性") PPUserSex.PPUserSexMale else PPUserSex.PPUserSexFemal

        val genderTextView = findViewById<TextView>(R.id.gender)
        val ageTextView = findViewById<TextView>(R.id.age)
        val heightTextView = findViewById<TextView>(R.id.height)

        genderTextView.text = genderText
        ageTextView.text = age
        heightTextView.text = height

        unitType = PPUnitType.values()[0]

        userModel = PPUserModel.Builder().setAge(ageInput.toInt())
                .setHeight(heightInput.toInt())
                .setSex(gender)
                .setGroupNum(0)
                .build()

        ppScale = PPScale.Builder(this)
                .setProtocalFilterImpl(getProtocalFilter())
                .setBleOptions(getBleOptions())
                .setUserModel(userModel)
                .setBleStateInterface(bleStateInterface)
                .build()
        ppScale!!.startSearchBluetoothScaleWithMacAddressList(30 * 1000)

    }

    private fun getProtocalFilter(): ProtocalFilterImpl? {
        val protocalFilter = ProtocalFilterImpl()
        protocalFilter.setPPProcessDateInterface { bodyBaseModel ->
            Logger.d("bodyBaseModel scaleName " + bodyBaseModel.scaleName)
            val weightText = bodyBaseModel.ppWeightKg.toString() + "kg"
            weightTextView!!.setText(weightText)
        }
        protocalFilter.setPPLockDataInterface { bodyFatModel, deviceModel ->
            if (bodyFatModel.isHeartRateEnd) {
                if (bodyFatModel != null) {
                    Logger.d("monitorLockData  bodyFatModel weightKg = " + bodyFatModel!!.ppWeightKg)
                } else {
                    Logger.d("monitorLockData  bodyFatModel heartRate = " + bodyFatModel!!.ppHeartRate)
                }
                if (weightTextView != null) {
                    statusTextView!!.setText("測定終了")
                    val weightText = bodyFatModel.ppWeightKg.toString() + "kg"
                    weightTextView!!.setText(weightText)
                    val BMIText = (Math.round(bodyFatModel.ppBMI * 100.0) / 100.0).toString()
                    val BodyfatPercentageText = (Math.round(bodyFatModel.ppBodyfatPercentage * 100.0) / 100.0).toString() + "%"
                    val MuscleKgText = (Math.round(bodyFatModel.ppMuscleKg * 100.0) / 100.0).toString() + "kg"
                    val WaterPercentageText = (Math.round(bodyFatModel.ppWaterPercentage * 100.0) / 100.0).toString() + "%"
                    val VFALText = bodyFatModel.ppVFAL.toString()
                    val BoneKgText = (Math.round(bodyFatModel.ppBoneKg * 100.0) / 100.0).toString() + "kg"
                    val BMRText = bodyFatModel.ppBMR.toString() + "Kcal"
                    val ProteinPercentageText = (Math.round(bodyFatModel.ppProteinPercentage * 100.0) / 100.0).toString() + "%"
                    val VFPercentageText = (Math.round(bodyFatModel.ppVFPercentage * 100.0) / 100.0).toString() + "%"
                    val LoseFatWeightKgText = (Math.round(bodyFatModel.ppLoseFatWeightKg * 100.0) / 100.0).toString() + "kg"
                    val BodystandardText = (Math.round(bodyFatModel.ppBodystandard * 100.0) / 100.0).toString() + "kg"
                    intent.apply {
                        putExtra("status", "success")
                        putExtra("weight", weightText)
                        putExtra("BMI", BMIText)
                        putExtra("BodyfatPercentage", BodyfatPercentageText)
                        putExtra("MuscleKg", MuscleKgText)
                        putExtra("WaterPercentage", WaterPercentageText)
                        putExtra("VFAL", VFALText)
                        putExtra("BoneKg", BoneKgText)
                        putExtra("BMR", BMRText)
                        putExtra("ProteinPercentage", ProteinPercentageText)
                        putExtra("VFPercentage", VFPercentageText)
                        putExtra("LoseFatWeightKg", LoseFatWeightKgText)
                        putExtra("Bodystandard", BodystandardText)
                    }
                }
            } else {
                Logger.d("心拍数測定中")
            }
        }
        return protocalFilter
    }

    private fun getBleOptions(): BleOptions? {
        return BleOptions.Builder()
                .setFeaturesFlag(BleOptions.ScaleFeatures.FEATURES_ALL)
                .setUnitType(unitType)
                .build()
    }

    var bleStateInterface: PPBleStateInterface = object : PPBleStateInterface {
        override fun monitorBluetoothWorkState(ppBleWorkState: PPBleWorkState) {
            if (ppBleWorkState == PPBleWorkState.PPBleWorkStateConnected) {
                Logger.d(getString(R.string.device_connected))
            } else if (ppBleWorkState == PPBleWorkState.PPBleWorkStateConnecting) {
                Logger.d(getString(R.string.device_connecting))
            } else if (ppBleWorkState == PPBleWorkState.PPBleWorkStateDisconnected) {
                Logger.d(getString(R.string.device_disconnected))
            } else if (ppBleWorkState == PPBleWorkState.PPBleWorkStateStop) {
                Logger.d(getString(R.string.stop_scanning))
            } else if (ppBleWorkState == PPBleWorkState.PPBleWorkStateSearching) {
                Logger.d(getString(R.string.scanning))
            } else {
                Logger.e(getString(R.string.bluetooth_status_is_abnormal))
            }
        }

        override fun monitorBluetoothSwitchState(ppBleSwitchState: PPBleSwitchState) {
            if (ppBleSwitchState == PPBleSwitchState.PPBleSwitchStateOff) {
                Logger.e(getString(R.string.system_bluetooth_disconnect))
                Toast.makeText(this@NextActivity, getString(R.string.system_bluetooth_disconnect), Toast.LENGTH_SHORT).show()
            } else if (ppBleSwitchState == PPBleSwitchState.PPBleSwitchStateOn) {
                Logger.d(getString(R.string.system_blutooth_on))
                Toast.makeText(this@NextActivity, getString(R.string.system_blutooth_on), Toast.LENGTH_SHORT).show()
            } else {
                Logger.e(getString(R.string.system_bluetooth_abnormal))
            }
        }
    }
}