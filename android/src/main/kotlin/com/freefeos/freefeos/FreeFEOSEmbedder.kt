package com.freefeos.freefeos

import android.app.Activity
import android.app.Service
import android.content.ComponentName
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.content.res.TypedArray
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.ActionBarDrawerToggle
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AppCompatCallback
import androidx.appcompat.app.AppCompatDelegate
import androidx.appcompat.view.ActionMode
import androidx.appcompat.widget.Toolbar
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import com.blankj.utilcode.util.AppUtils
import com.blankj.utilcode.util.IntentUtils
import com.blankj.utilcode.util.PermissionUtils
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import org.json.JSONObject
import rikka.shizuku.Shizuku

/**
 * 作者: wyq0918dev
 * 仓库: https://github.com/freefeos/freefeos
 * 时间: 2024/10/01
 * 描述: freefeos
 * 文档: https://github.com/freefeos/freefeos/blob/master/README.md
 */
class FreeFEOSEmbedder : Service(), FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    /** Flutter插件方法通道 */
    private lateinit var mMethodChannel: MethodChannel

    /** 插件绑定器. */
    private var mBinding: PluginBinding? = null

    /** 插件列表. */
    private var mPluginList: ArrayList<EmbedderPlugin>? = null

    /** JSON插件列表 */
    private var mJSONList: ArrayList<String>? = null


    /** Activity */
    private var mActivity: Activity? = null

    /** 生命周期 */
    private var mLifecycle: Lifecycle? = null

    /** Delegate基本上下文 */
    private lateinit var mAppCompatDelegateBaseContext: Context

    /** 供引擎使用的基本调试布尔值 */
    private val mBaseDebug: Boolean = AppUtils.isAppDebug()

    /** 全局调试布尔值 */
    private var mFullDebug: Boolean = false

    /** 此服务意图 */
    private lateinit var mEmbedderServicesIntent: Intent

    /** 服务AIDL接口 */
    private var mAIDL: IFreeFEOS? = null
    private var mIUserService: IUserService? = null

    /** 服务绑定状态 */
    private var mIsBind: Boolean = false


    /** AppCompatDelegate */
    private lateinit var mAppCompatDelegate: AppCompatDelegate

    /** 调试对话框 */
    private lateinit var mDebugDialog: AlertDialog

    /** 工具栏 */
    private lateinit var mToolbar: Toolbar

    private val hideHandler = Handler(Looper.myLooper()!!)

    private val showPart2Runnable = Runnable {
        getActionBar()?.show()
    }

    /** 工具栏显示状态 */
    private var isVisible: Boolean = false

    private val hideRunnable = Runnable {
        hide()
    }

    private val delayHideTouchListener = View.OnTouchListener { view, motionEvent ->
        when (motionEvent.action) {
            MotionEvent.ACTION_DOWN -> if (AUTO_HIDE) delayedHide()
            MotionEvent.ACTION_UP -> view.performClick()
            else -> {}
        }
        false
    }

    private val mUserServiceArgs = Shizuku.UserServiceArgs(
        ComponentName(
            AppUtils.getAppPackageName(),
            UserService().javaClass.name,
        )
    ).daemon(true).processNameSuffix("service").debuggable(mFullDebug)
        .version(AppUtils.getAppVersionCode())

    /**
     ***********************************************************************************************
     * 分类: Service生命周期
     ***********************************************************************************************
     */

    /**
     * 服务创建时执行
     */
    override fun onCreate() {
        super.onCreate()

        shizukuScope {
            // 添加Shizuku监听
            Shizuku.addBinderReceivedListener(this@shizukuScope)
            Shizuku.addBinderDeadListener(this@shizukuScope)
            Shizuku.addRequestPermissionResultListener(this@shizukuScope)
        }


        // 申请Shizuku权限

        //checkPermission(0)


//        if (AppUtils.isAppInstalled(EcosedManifest.ShizukuPackage)) {
//
//        } else {
//
//        }
//        try {
//            if (Shizuku.checkSelfPermission() != PackageManager.PERMISSION_GRANTED){
//                Shizuku.requestPermission(0)
//            } else {
//                // 有权限
//            }
//        } catch (e: Exception) {
//            if (e.javaClass == IllegalStateException().javaClass) {
//                // 没激活
//            }
//        }


//        // 申请签名欺骗权限
//        val fake = PermissionUtils.permission(EcosedManifest.FAKE_PACKAGE_SIGNATURE)
//        fake.callback { isAllGranted, granted, deniedForever, denied -> }
//        fake.request()


        // 检查GMS


        // 绑定Shizuku服务
        //Shizuku.bindUserService(mUserServiceArgs, this@EcosedKitPlugin)


    }

    /**
     * 开始服务时执行
     */
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return super.onStartCommand(intent, flags, startId)
    }

    /**
     * 服务绑定时执行
     */
    override fun onBind(intent: Intent): IBinder {
        // 通过服务调用单元调用服务内部类进行绑定
        return serviceScope {
            return@serviceScope getBinder(
                intent = intent
            )
        }
    }

    /**
     * 重新绑定时执行
     */
    override fun onRebind(intent: Intent?) {
        super.onRebind(intent)
    }

    /**
     * 解除绑定时执行
     */
    override fun onUnbind(intent: Intent?): Boolean {
        return super.onUnbind(intent)
    }

    /**
     * 服务销毁时执行
     */
    override fun onDestroy() {
        super.onDestroy()
        // 移除Shizuku监听
        shizukuScope {
            Shizuku.removeBinderDeadListener(this@shizukuScope)
            Shizuku.removeBinderReceivedListener(this@shizukuScope)
            Shizuku.removeRequestPermissionResultListener(this@shizukuScope)
        }
        // 解绑Shizuku服务
        connectScope {
            Shizuku.unbindUserService(
                this@FreeFEOSEmbedder.mUserServiceArgs,
                this@connectScope,
                true,
            )
        }
    }

    /**
     ***********************************************************************************************
     * 分类: Flutter插件方法
     ***********************************************************************************************
     */

    /**
     * 将插件添加到引擎
     */
    override fun onAttachedToEngine(
        binding: FlutterPlugin.FlutterPluginBinding
    ): Unit = bridgeScope {
        // 初始化方法通道
        this@FreeFEOSEmbedder.mMethodChannel = MethodChannel(
            binding.binaryMessenger,
            FreeFEOSChannel.FLUTTER_CHANNEL_NAME,
        )
        // 设置方法通道回调程序
        this@FreeFEOSEmbedder.mMethodChannel.setMethodCallHandler(
            this@FreeFEOSEmbedder,
        )
        binding.platformViewRegistry.registerViewFactory(
            "freefeos_toolbar", nativeViewFactory
        )
        // 初始化引擎
        return@bridgeScope this@bridgeScope.onCreateEngine(
            context = binding.applicationContext,
        )


    }

    private val nativeViewFactory = object : PlatformViewFactory(
        StandardMessageCodec.INSTANCE
    ) {
        override fun create(
            context: Context,
            viewId: Int,
            args: Any?,
        ): PlatformView = object : PlatformView {
            override fun getView(): View = mToolbar
            override fun dispose() = Unit
        }
    }

    /**
     * 将插件从引擎移除
     */
    override fun onDetachedFromEngine(
        binding: FlutterPlugin.FlutterPluginBinding
    ): Unit = bridgeScope {
        // 清空回调程序释放内存
        this@FreeFEOSEmbedder.mMethodChannel.setMethodCallHandler(null)
        // 销毁引擎释放资源
        return@bridgeScope this@bridgeScope.onDestroyEngine()
    }

    /**
     * 调用方法
     */
    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ): Unit = bridgeScope {
        return@bridgeScope this@bridgeScope.onMethodCall(
            call = object : MethodCallProxy {

                override val methodProxy: String
                    get() = call.method

                override val bundleProxy: Bundle
                    get() = Bundle().let { bundle ->
                        bundle.putString("channel", call.argument<String>("channel"))
                        return@let bundle
                    }
            },
            result = object : ResultProxy {

                override fun success(
                    resultProxy: Any?,
                ) = result.success(
                    resultProxy
                )

                override fun error(
                    errorCodeProxy: String,
                    errorMessageProxy: String?,
                    errorDetailsProxy: Any?,
                ) = result.error(
                    errorCodeProxy,
                    errorMessageProxy,
                    errorDetailsProxy,
                )

                override fun notImplemented() = result.notImplemented()
            },
        )
    }

    /**
     * 附加到Activity
     */
    override fun onAttachedToActivity(
        binding: ActivityPluginBinding,
    ): Unit = bridgeScope {
        // 获取活动
        this@bridgeScope.onCreateActivity(
            activity = binding.activity
        )
        // 获取生命周期
        this@bridgeScope.onCreateLifecycle(
            lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding)
        )
        // activity回调
        binding.addActivityResultListener { requestCode, resultCode, data ->
            return@addActivityResultListener this@bridgeScope.onActivityResult(
                requestCode, resultCode, data
            )
        }
        // 请求权限回调
        binding.addRequestPermissionsResultListener { requestCode, permissions, grantResults ->
            return@addRequestPermissionsResultListener this@bridgeScope.onRequestPermissionsResult(
                requestCode, permissions, grantResults
            )
        }
    }

    /**
     * 配置变更时从Activity分离
     */
    override fun onDetachedFromActivityForConfigChanges() {
        this@FreeFEOSEmbedder.onDetachedFromActivity()
    }

    /**
     * 配置变更完成后重新附加到Activity
     */
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this@FreeFEOSEmbedder.onAttachedToActivity(binding = binding)
    }

    /**
     * 从Activity分离
     */
    override fun onDetachedFromActivity(): Unit = bridgeScope {
        this@bridgeScope.onDestroyActivity()
        this@bridgeScope.onDestroyLifecycle()
    }

    /**
     ***********************************************************************************************
     * 分类: 内部基本接口方法
     ***********************************************************************************************
     */

    /**
     * Flutter插件代理
     */
    private interface FlutterPluginProxy {

        /** 注册Activity引用 */
        fun onCreateActivity(activity: Activity)

        /** 注销Activity引用 */
        fun onDestroyActivity()

        /** 注册生命周期监听器 */
        fun onCreateLifecycle(lifecycle: Lifecycle)

        /** 注销生命周期监听器释放资源避免内存泄露 */
        fun onDestroyLifecycle()

        fun onActivityResult(
            requestCode: Int,
            resultCode: Int,
            data: Intent?,
        ): Boolean

        fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray,
        ): Boolean

        /** 引擎初始化 */
        fun onCreateEngine(context: Context)

        /** 引擎销毁 */
        fun onDestroyEngine()

        /** 方法调用 */
        fun onMethodCall(
            call: MethodCallProxy,
            result: ResultProxy,
        )
    }

    /**
     * 方法调用代理
     */
    private interface MethodCallProxy {

        /** 方法名代理 */
        val methodProxy: String

        /** 传入参数代理 */
        val bundleProxy: Bundle
    }

    /**
     * 返回内容代理
     */
    private interface ResultProxy {

        /**
         * 处理成功结果.
         * @param resultProxy 处理成功结果,注意可能为空.
         */
        fun success(resultProxy: Any?)

        /**
         * 处理错误结果.
         * @param errorCodeProxy 错误代码.
         * @param errorMessageProxy 错误消息,注意可能为空.
         * @param errorDetailsProxy 详细信息,注意可能为空.
         */
        fun error(
            errorCodeProxy: String,
            errorMessageProxy: String?,
            errorDetailsProxy: Any?,
        )

        /**
         * 处理对未实现方法的调用.
         */
        fun notImplemented()
    }

    /**
     * 用于调用方法的接口.
     */
    private interface PluginMethodCall {

        /**
         * 要调用的方法名.
         */
        val method: String?

        /**
         * 要传入的参数.
         */
        val bundle: Bundle?
    }

    /**
     * 方法调用结果回调.
     */
    private interface PluginResult {

        /**
         * 处理成功结果.
         * @param result 处理成功结果,注意可能为空.
         */
        fun success(result: Any?)

        /**
         * 处理错误结果.
         * @param errorCode 错误代码.
         * @param errorMessage 错误消息,注意可能为空.
         * @param errorDetails 详细信息,注意可能为空.
         */
        fun error(
            errorCode: String,
            errorMessage: String?,
            errorDetails: Any?,
        ): Nothing

        /**
         * 处理对未实现方法的调用.
         */
        fun notImplemented()
    }

    /**
     * 引擎包装器
     */
    private interface EngineWrapper : FlutterPluginProxy {

        /**
         * 执行方法
         * @param channel 插件通道
         * @param method 插件方法
         * @param bundle 传值
         * @return 执行插件方法返回值
         */
        fun <T> execMethodCall(
            channel: String,
            method: String,
            bundle: Bundle?,
        ): T?
    }

    /**
     * 回调
     */
    private interface InvokeWrapper {

        /** 在服务绑定成功时回调 */
        fun onEmbedderConnected()

        /** 在服务解绑或意外断开链接时回调 */
        fun onEmbedderDisconnected()

        /** 在服务端服务未启动时绑定服务时回调 */
        fun onEmbedderDead()

        /** 在未绑定服务状态下调用API时回调 */
        fun onEmbedderUnbind()
    }

    /**
     * 生命周期包装器
     */
    private interface LifecycleWrapper : LifecycleOwner, DefaultLifecycleObserver

    /**
     * 服务链接包装器
     */
    private interface ConnectWrapper : ServiceConnection

    /**
     * Shizuku包装器
     * 具有Shizuku监听器方法
     */
    private interface ShizukuWrapper : Shizuku.OnBinderReceivedListener,
        Shizuku.OnBinderDeadListener, Shizuku.OnRequestPermissionResultListener

    /**
     * AppCompat包装器
     * 方法回调和操作栏抽屉状态切换
     */
    private interface AppCompatWrapper : AppCompatCallback, ActionBarDrawerToggle.DelegateProvider

    /**
     * 服务插件包装器
     */
    private interface DelegateWrapper : ConnectWrapper, ShizukuWrapper, AppCompatWrapper,
        LifecycleWrapper {

        /**
         * 获取Binder
         */
        fun getBinder(intent: Intent): IBinder

        /**
         * 附加代理基本上下文
         */
        fun attachDelegateBaseContext()
    }

    /**
     ***********************************************************************************************
     * 分类: 插件基类实现
     ***********************************************************************************************
     */

    /**
     * 基本插件
     */
    private abstract class EmbedderPlugin : ContextWrapper(null) {

        /** 插件通道 */
        private lateinit var mPluginChannel: PluginChannel

        /** 引擎 */
        private lateinit var mEngine: EngineWrapper

        /** 是否调试模式 */
        private var mDebug: Boolean = false

        /**
         * 附加基本上下文
         */
        override fun attachBaseContext(base: Context?) {
            super.attachBaseContext(base)
        }

        /**
         * 插件添加时执行
         */
        open fun onPluginAdded(binding: PluginBinding) {
            // 初始化插件通道
            this@EmbedderPlugin.mPluginChannel = PluginChannel(
                binding = binding,
                channel = this@EmbedderPlugin.channel,
            )
            // 插件附加基本上下文
            this@EmbedderPlugin.attachBaseContext(
                base = this@EmbedderPlugin.mPluginChannel.getContext()
            )
            // 引擎
            this@EmbedderPlugin.mEngine = this@EmbedderPlugin.mPluginChannel.getEngine()
            // 获取是否调试模式
            this@EmbedderPlugin.mDebug = this@EmbedderPlugin.mPluginChannel.isDebug()
            // 设置调用
            this@EmbedderPlugin.mPluginChannel.setMethodCallHandler(
                handler = this@EmbedderPlugin
            )
        }

        /** 获取插件通道 */
        val getPluginChannel: PluginChannel
            get() = this@EmbedderPlugin.mPluginChannel

        /** 需要子类重写的插件标题 */
        abstract val title: String

        /** 需要子类重写的通道名称 */
        abstract val channel: String

        /** 需要子类重写的插件作者 */
        abstract val author: String

        /** 需要子类重写的插件描述 */
        abstract val description: String

        /** 供子类使用的判断调试模式的接口 */
        protected val isDebug: Boolean
            get() = this@EmbedderPlugin.mDebug

        /**
         * 执行方法
         * @param channel 插件通道
         * @param method 插件方法
         * @param bundle 传值
         * @return 执行插件方法返回值
         */
        open fun <T> execPluginMethod(
            channel: String,
            method: String,
            bundle: Bundle?,
        ): T? = this@EmbedderPlugin.mEngine.execMethodCall<T>(
            channel = channel,
            method = method,
            bundle = bundle,
        )

        /**
         * 插件调用方法
         */
        open fun onPluginMethodCall(
            call: PluginMethodCall,
            result: PluginResult,
        ) = Unit
    }

    /**
     * 插件绑定器
     */
    private class PluginBinding(
        debug: Boolean,
        context: Context,
        engine: EngineWrapper,
    ) {

        /** 是否调试模式. */
        private val mDebug: Boolean = debug

        /** 应用程序全局上下文. */
        private val mContext: Context = context

        /** 引擎 */
        private val mEngine: EngineWrapper = engine

        /**
         * 是否调试模式.
         * @return Boolean.
         */
        fun isDebug(): Boolean = this@PluginBinding.mDebug

        /**
         * 获取上下文.
         * @return Context.
         */
        fun getContext(): Context = this@PluginBinding.mContext

        /**
         * 获取引擎
         * @return EngineWrapper.
         */
        fun getEngine(): EngineWrapper = this@PluginBinding.mEngine
    }

    /**
     * 插件通信通道
     */
    private class PluginChannel(
        binding: PluginBinding,
        channel: String,
    ) {

        /** 插件绑定器. */
        private var mBinding: PluginBinding = binding

        /** 插件通道. */
        private var mChannel: String = channel

        /** 方法调用处理接口. */
        private var mPlugin: EmbedderPlugin? = null

        /** 方法名. */
        private var mMethod: String? = null

        /** 参数Bundle. */
        private var mBundle: Bundle? = null

        /** 返回结果. */
        private var mResult: Any? = null

        /**
         * 设置方法调用.
         * @param handler 执行方法时调用PluginMethodCallHandler.
         */
        fun setMethodCallHandler(handler: EmbedderPlugin) {
            this@PluginChannel.mPlugin = handler
        }

        /**
         * 获取上下文.
         * @return Context.
         */
        fun getContext(): Context = this@PluginChannel.mBinding.getContext()

        /**
         * 是否调试模式.
         * @return Boolean.
         */
        fun isDebug(): Boolean = this@PluginChannel.mBinding.isDebug()

        /**
         * 获取通道.
         * @return 通道名称.
         */
        fun getChannel(): String = this@PluginChannel.mChannel

        /**
         * 获取引擎.
         * @return 引擎.
         */
        fun getEngine(): EngineWrapper = this@PluginChannel.mBinding.getEngine()

        /**
         * 执行方法回调.
         * @param name 通道名称.
         * @param method 方法名称.
         * @return 方法执行后的返回值.
         */
        @Suppress("UNCHECKED_CAST")
        fun <T> execMethodCall(
            name: String,
            method: String?,
            bundle: Bundle?,
        ): T? {
            this@PluginChannel.mMethod = method
            this@PluginChannel.mBundle = bundle
            if (name == this@PluginChannel.mChannel) {
                this@PluginChannel.mPlugin?.onPluginMethodCall(
                    call = this@PluginChannel.call,
                    result = this@PluginChannel.result,
                )
            }
            return this@PluginChannel.mResult as T?
        }

        /** 用于调用方法的接口. */
        private val call: PluginMethodCall = object : PluginMethodCall {

            /**
             * 要调用的方法名.
             */
            override val method: String?
                get() = this@PluginChannel.mMethod

            /**
             * 要传入的参数.
             */
            override val bundle: Bundle?
                get() = this@PluginChannel.mBundle
        }

        /** 方法调用结果回调. */
        private val result: PluginResult = object : PluginResult {

            /**
             * 处理成功结果.
             */
            override fun success(result: Any?) {
                this@PluginChannel.mResult = result
            }

            /**
             * 处理错误结果.
             */
            override fun error(
                errorCode: String,
                errorMessage: String?,
                errorDetails: Any?,
            ): Nothing = error(
                message = "错误代码:$errorCode\n错误消息:$errorMessage\n详细信息:$errorDetails"
            )

            /**
             * 处理对未实现方法的调用.
             */
            override fun notImplemented() {
                this@PluginChannel.mResult = null
            }
        }

    }

    /**
     ***********************************************************************************************
     * 分类: 核心内部类实现
     ***********************************************************************************************
     */

    /** 引擎桥接 */
    private val mEngineBridge: EmbedderPlugin = object : EmbedderPlugin(), FlutterPluginProxy {

        /** 插件标题 */
        override val title: String
            get() = "EngineBridge"

        /** 插件通道 */
        override val channel: String
            get() = FreeFEOSChannel.BRIDGE_CHANNEL_NAME

        /** 插件作者 */
        override val author: String
            get() = FreeFEOSResources.DEFAULT_AUTHOR

        /** 插件描述 */
        override val description: String
            get() = "FlutterEngine与EmbedderEngine通信的的桥梁"

        override fun onCreateActivity(activity: Activity) = engineScope {
            return@engineScope this@engineScope.onCreateActivity(activity = activity)
        }

        override fun onDestroyActivity() = engineScope {
            return@engineScope this@engineScope.onDestroyActivity()
        }

        override fun onCreateLifecycle(lifecycle: Lifecycle) = engineScope {
            return@engineScope this@engineScope.onCreateLifecycle(lifecycle = lifecycle)
        }

        override fun onDestroyLifecycle() = engineScope {
            return@engineScope this@engineScope.onDestroyLifecycle()
        }

        override fun onActivityResult(
            requestCode: Int,
            resultCode: Int,
            data: Intent?,
        ): Boolean = engineScope {
            return@engineScope this@engineScope.onActivityResult(
                requestCode = requestCode,
                resultCode = resultCode,
                data = data,
            )
        }

        override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray,
        ): Boolean = engineScope {
            return@engineScope this@engineScope.onRequestPermissionsResult(
                requestCode = requestCode,
                permissions = permissions,
                grantResults = grantResults,
            )
        }

        override fun onCreateEngine(context: Context) = engineScope {
            return@engineScope this@engineScope.onCreateEngine(context = context)
        }

        override fun onDestroyEngine() = engineScope {
            return@engineScope this@engineScope.onDestroyEngine()
        }

        override fun onMethodCall(call: MethodCallProxy, result: ResultProxy) = engineScope {
            return@engineScope this@engineScope.onMethodCall(call = call, result = result)
        }
    }

    /** 引擎 */
    private val mFreeFEOSEngine: EmbedderPlugin = object : EmbedderPlugin(), EngineWrapper {

        /** 插件标题 */
        override val title: String
            get() = "FreeFEOSEngine"

        /** 插件通道 */
        override val channel: String
            get() = FreeFEOSChannel.ENGINE_CHANNEL_NAME

        /** 插件作者 */
        override val author: String
            get() = FreeFEOSResources.DEFAULT_AUTHOR

        /** 插件描述 */
        override val description: String
            get() = "FreeFEOS Engine"

        override fun onCreateActivity(activity: Activity) {
            this@FreeFEOSEmbedder.mActivity = activity
        }

        override fun onDestroyActivity() {
            this@FreeFEOSEmbedder.mActivity = null
        }

        override fun onCreateLifecycle(lifecycle: Lifecycle) = lifecycleScope {
            this@FreeFEOSEmbedder.mLifecycle = lifecycle
            this@lifecycleScope.lifecycle.addObserver(this@lifecycleScope)
        }

        override fun onDestroyLifecycle(): Unit = lifecycleScope {
            this@lifecycleScope.lifecycle.removeObserver(this@lifecycleScope)
            this@FreeFEOSEmbedder.mLifecycle = null
        }

        override fun onActivityResult(
            requestCode: Int,
            resultCode: Int,
            data: Intent?,
        ): Boolean {

            return true
        }

        override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray,
        ): Boolean {

            return true
        }

        /**
         * 引擎初始化时执行
         */
        override fun onPluginAdded(binding: PluginBinding): Unit = run {
            super.onPluginAdded(binding)
            // 设置来自插件的全局调试布尔值
            this@FreeFEOSEmbedder.mFullDebug = this@run.isDebug
        }

        override fun onPluginMethodCall(call: PluginMethodCall, result: PluginResult) {
            super.onPluginMethodCall(call, result)
            when (call.method) {
                FreeFEOSMethod.GET_PLUGINS_METHOD -> result.success(
                    result = this@FreeFEOSEmbedder.mJSONList
                )

                FreeFEOSMethod.OPEN_DIALOG_METHOD -> result.success(
                    result = execPluginMethod<Boolean>(
                        channel = FreeFEOSChannel.INVOKE_CHANNEL_NAME,
                        method = FreeFEOSMethod.OPEN_DIALOG_METHOD,
                        bundle = Bundle()
                    )
                )

                FreeFEOSMethod.CLOSE_DIALOG_METHOD -> result.success(
                    result = execPluginMethod<Boolean>(
                        channel = FreeFEOSChannel.INVOKE_CHANNEL_NAME,
                        method = FreeFEOSMethod.CLOSE_DIALOG_METHOD,
                        bundle = Bundle()
                    )
                )

                else -> result.notImplemented()
            }
        }

        /**
         * 引擎初始化.
         * @param context 上下文 - 此上下文来自FlutterPlugin的ApplicationContext
         */
        override fun onCreateEngine(context: Context) {
            when {
                this@FreeFEOSEmbedder.mPluginList.isNull or this@FreeFEOSEmbedder.mJSONList.isNull or this@FreeFEOSEmbedder.mBinding.isNull -> pluginScope(
                    debug = this@FreeFEOSEmbedder.mBaseDebug,
                    context = context,
                ) { plugins, binding ->
                    // 初始化插件列表.
                    this@FreeFEOSEmbedder.mPluginList = arrayListOf()
                    this@FreeFEOSEmbedder.mJSONList = arrayListOf()
                    // 添加所有插件.
                    plugins.forEach { plugin ->
                        plugin.apply {
                            try {
                                this@apply.onPluginAdded(binding = binding)
                                if (this@FreeFEOSEmbedder.mBaseDebug) Log.d(
                                    PLUGIN_TAG,
                                    "插件${this@apply.javaClass.name}已加载",
                                )
                            } catch (exception: Exception) {
                                if (this@FreeFEOSEmbedder.mBaseDebug) Log.e(
                                    PLUGIN_TAG,
                                    "插件${this@apply.javaClass.name}添加失败!",
                                    exception,
                                )
                            }
                        }.run {
                            this@FreeFEOSEmbedder.mPluginList?.add(
                                element = this@run
                            )
                            this@FreeFEOSEmbedder.mJSONList?.add(
                                element = JSONObject().let { json ->
                                    json.put("channel", this@run.channel)
                                    json.put("title", this@run.title)
                                    json.put("description", this@run.description)
                                    json.put("author", this@run.author)
                                    return@let json.toString()
                                },
                            )
                            if (this@FreeFEOSEmbedder.mBaseDebug) Log.d(
                                PLUGIN_TAG,
                                "插件${this@run.javaClass.name}已添加到插件列表",
                            )
                        }
                    }
                }

                else -> if (this@FreeFEOSEmbedder.mBaseDebug) Log.e(
                    PLUGIN_TAG, "请勿重复执行onCreateEngine!"
                ) else Unit
            }
        }

        /**
         * 销毁引擎释放资源.
         */
        override fun onDestroyEngine() {
            when {
                this@FreeFEOSEmbedder.mPluginList.isNotNull or this@FreeFEOSEmbedder.mJSONList.isNotNull or this@FreeFEOSEmbedder.mBinding.isNotNull -> {
                    // 清空插件列表
                    this@FreeFEOSEmbedder.mPluginList = null
                    this@FreeFEOSEmbedder.mJSONList = null
                }

                else -> if (this@FreeFEOSEmbedder.mBaseDebug) Log.e(
                    PLUGIN_TAG,
                    "请勿重复执行onDestroyEngine!",
                ) else Unit
            }
        }

        /**
         * 方法调用
         * 此方法通过Flutter插件代理类[FlutterPluginProxy]实现
         * 此方法等价与MethodCallHandler的onMethodCall方法
         * 但参数传递是依赖Bundle进行的
         */
        override fun onMethodCall(
            call: MethodCallProxy,
            result: ResultProxy,
        ) {
            try {
                // 执行代码并获取执行后的返回值
                execMethodCall<Any>(
                    channel = call.bundleProxy.getString(
                        "channel",
                        FreeFEOSChannel.ENGINE_CHANNEL_NAME,
                    ),
                    method = call.methodProxy,
                    bundle = call.bundleProxy,
                ).apply {
                    // 判断是否为空并提交数据
                    if (this@apply.isNotNull) result.success(
                        resultProxy = this@apply
                    ) else result.notImplemented()
                }
            } catch (e: Exception) {
                // 抛出异常
                result.error(
                    errorCodeProxy = PLUGIN_TAG,
                    errorMessageProxy = "engine: onMethodCall",
                    errorDetailsProxy = Log.getStackTraceString(e),
                )
            }
        }

        /**
         * 调用插件代码的方法.
         * @param channel 要调用的插件的通道.
         * @param method 要调用的插件中的方法.
         * @param bundle 通过Bundle传递参数.
         * @return 返回方法执行后的返回值,类型为Any?.
         */
        override fun <T> execMethodCall(
            channel: String,
            method: String,
            bundle: Bundle?,
        ): T? {
            var result: T? = null
            try {
                this@FreeFEOSEmbedder.mPluginList?.forEach { plugin ->
                    plugin.getPluginChannel.let { pluginChannel ->
                        if (pluginChannel.getChannel() == channel) {
                            result = pluginChannel.execMethodCall<T>(
                                name = channel,
                                method = method,
                                bundle = bundle,
                            )
                            if (this@FreeFEOSEmbedder.mBaseDebug) Log.d(
                                PLUGIN_TAG,
                                "插件代码调用成功!\n" + "通道名称:${channel}.\n" + "方法名称:${method}.\n" + "返回结果:${result}.",
                            )
                        }
                    }
                }
            } catch (exception: Exception) {
                if (this@FreeFEOSEmbedder.mBaseDebug) {
                    Log.e(
                        PLUGIN_TAG,
                        "插件代码调用失败!",
                        exception,
                    )
                }
            }
            return result
        }
    }

    /** 负责与服务通信的客户端 */
    private val mServiceInvoke: EmbedderPlugin = object : EmbedderPlugin(), InvokeWrapper {

        /** 插件标题 */
        override val title: String
            get() = "ServiceInvoke"

        /** 插件通道 */
        override val channel: String
            get() = FreeFEOSChannel.INVOKE_CHANNEL_NAME

        /** 插件作者 */
        override val author: String
            get() = FreeFEOSResources.DEFAULT_AUTHOR

        /** 插件描述 */
        override val description: String
            get() = "负责与服务通信的服务调用"

        /**
         * 插件添加时执行
         */
        override fun onPluginAdded(binding: PluginBinding) = run {
            super.onPluginAdded(binding)
            this@FreeFEOSEmbedder.mEmbedderServicesIntent = Intent(
                this@run,
                this@FreeFEOSEmbedder.javaClass,
            )
            this@FreeFEOSEmbedder.mEmbedderServicesIntent.action = FreeFEOSManifest.ACTION

            startService(this@FreeFEOSEmbedder.mEmbedderServicesIntent)
            bindEmbedder(this@run)

            Toast.makeText(this@run, "client", Toast.LENGTH_SHORT).show()
        }

        /**
         * 插件方法调用
         */
        override fun onPluginMethodCall(call: PluginMethodCall, result: PluginResult) {
            super.onPluginMethodCall(call, result)
            when (call.method) {
                FreeFEOSMethod.OPEN_DIALOG_METHOD -> result.success(result = invokeMethod {
                    openDialog()
                })

                FreeFEOSMethod.CLOSE_DIALOG_METHOD -> result.success(result = invokeMethod {
                    closeDialog()
                })

                else -> result.notImplemented()
            }
        }

        /**
         * 在服务绑定成功时回调
         */
        override fun onEmbedderConnected() {
            Toast.makeText(this, "onEmbedderConnected", Toast.LENGTH_SHORT).show()
        }

        /**
         * 在服务解绑或意外断开链接时回调
         */
        override fun onEmbedderDisconnected() {
            Toast.makeText(this, "onEmbedderDisconnected", Toast.LENGTH_SHORT).show()
        }

        /**
         * 在服务端服务未启动时绑定服务时回调
         */
        override fun onEmbedderDead() {
            Toast.makeText(this, "onEmbedderDead", Toast.LENGTH_SHORT).show()
        }

        /**
         * 在未绑定服务状态下调用API时回调
         */
        override fun onEmbedderUnbind() {
            Toast.makeText(this, "onEmbedderUnbind", Toast.LENGTH_SHORT).show()
        }
    }

    /** 服务相当于整个服务类部分无法在大类中实现的方法在此实现并调用 */
    private val mServiceDelegate: EmbedderPlugin = object : EmbedderPlugin(), DelegateWrapper {

        /** 插件标题 */
        override val title: String
            get() = "ServiceDelegate"

        /** 插件通道 */
        override val channel: String
            get() = FreeFEOSChannel.DELEGATE_CHANNEL_NAME

        /** 插件作者 */
        override val author: String
            get() = FreeFEOSResources.DEFAULT_AUTHOR

        /** 插件描述 */
        override val description: String
            get() = "服务功能代理, 无实际插件方法实现."

        override fun attachBaseContext(base: Context?): Unit = base?.run {
            super.attachBaseContext(base)
            this@FreeFEOSEmbedder.mAppCompatDelegateBaseContext = this@run
        } ?: Unit

        /**
         * 获取Binder
         * @param intent 意图
         * @return IBinder
         */
        override fun getBinder(intent: Intent): IBinder {
            return object : IFreeFEOS.Stub() {
                override fun getShizukuVersion(): String = shizukuVersion()
            }
        }

        override fun attachDelegateBaseContext() {
            this@FreeFEOSEmbedder.mAppCompatDelegate.attachBaseContext2(
                this@FreeFEOSEmbedder.mAppCompatDelegateBaseContext
            )
        }

        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            when (name?.className) {
                UserService().javaClass.name -> {
                    if (service.isNotNull and (service?.pingBinder() == true)) {
                        this@FreeFEOSEmbedder.mIUserService = IUserService.Stub.asInterface(service)
                    }
                    when {
                        this@FreeFEOSEmbedder.mIUserService.isNotNull -> {
                            Toast.makeText(this, "mIUserService", Toast.LENGTH_SHORT).show()
                        }

                        else -> if (this@FreeFEOSEmbedder.mFullDebug) Log.e(
                            PLUGIN_TAG, "UserService接口获取失败 - onServiceConnected"
                        )
                    }
                    when {
                        this@FreeFEOSEmbedder.mFullDebug -> Log.i(
                            PLUGIN_TAG, "服务已连接 - onServiceConnected"
                        )
                    }
                }

                this@FreeFEOSEmbedder.javaClass.name -> {
                    if (service.isNotNull and (service?.pingBinder() == true)) {
                        this@FreeFEOSEmbedder.mAIDL = IFreeFEOS.Stub.asInterface(service)
                    }
                    when {
                        this@FreeFEOSEmbedder.mAIDL.isNotNull -> {
                            this@FreeFEOSEmbedder.mIsBind = true
                            invokeScope {
                                onEmbedderConnected()
                            }
                        }

                        else -> if (this@FreeFEOSEmbedder.mFullDebug) Log.e(
                            PLUGIN_TAG, "AIDL接口获取失败 - onServiceConnected"
                        )
                    }
                    when {
                        mFullDebug -> Log.i(
                            PLUGIN_TAG, "服务已连接 - onServiceConnected"
                        )
                    }
                }

                else -> {

                }
            }
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            when (name?.className) {
                UserService().javaClass.name -> {

                }

                this@FreeFEOSEmbedder.javaClass.name -> {
                    this@FreeFEOSEmbedder.mIsBind = false
                    this@FreeFEOSEmbedder.mAIDL = null
                    unbindService(this)
                    invokeScope {
                        onEmbedderDisconnected()
                    }
                    if (this@FreeFEOSEmbedder.mFullDebug) {
                        Log.i(PLUGIN_TAG, "服务意外断开连接 - onServiceDisconnected")
                    }
                }

                else -> {

                }
            }

        }

        override fun onBindingDied(name: ComponentName?) {
            super.onBindingDied(name)
            when (name?.className) {
                UserService().javaClass.name -> {

                }

                this@FreeFEOSEmbedder.javaClass.name -> {

                }

                else -> {

                }
            }
        }

        override fun onNullBinding(name: ComponentName?) {
            super.onNullBinding(name)
            when (name?.className) {
                UserService().javaClass.name -> {

                }

                this@FreeFEOSEmbedder.javaClass.name -> {
                    if (this@FreeFEOSEmbedder.mFullDebug) {
                        Log.e(PLUGIN_TAG, "Binder为空 - onNullBinding")
                    }
                }

                else -> {

                }
            }
        }

        override fun onBinderReceived() {
            Toast.makeText(this, "onBinderReceived", Toast.LENGTH_SHORT).show()
        }

        override fun onBinderDead() {
            Toast.makeText(this, "onBinderDead", Toast.LENGTH_SHORT).show()
        }

        override fun onRequestPermissionResult(requestCode: Int, grantResult: Int) {
            Toast.makeText(this, "onRequestPermissionResult", Toast.LENGTH_SHORT).show()
        }

        override fun onSupportActionModeStarted(mode: ActionMode?) {

        }

        override fun onSupportActionModeFinished(mode: ActionMode?) {

        }

        override fun onWindowStartingSupportActionMode(callback: ActionMode.Callback?): ActionMode? {
            return null
        }

        override fun getDrawerToggleDelegate(): ActionBarDrawerToggle.Delegate? {
            return mAppCompatDelegate.drawerToggleDelegate
        }

        override val lifecycle: Lifecycle
            get() = mLifecycle ?: error(message = "lifecycle is null!")

        /**
         * 活动创建时执行
         */
        override fun onCreate(owner: LifecycleOwner): Unit = activityScope {
            super.onCreate(owner)
            // 初始化
            init {
                delegateScope {
                    // 调用Delegate onCreate函数
                    onCreate(Bundle())
                }
            }
            // 切换工具栏状态
            //toggle()

            // 执行Delegate函数
            if (this@activityScope.isNotAppCompat) delegateScope {
                onPostCreate(Bundle())
            }
        }

        /**
         * 活动启动时执行
         */
        override fun onStart(owner: LifecycleOwner): Unit = activityScope {
            super.onStart(owner)
            // 执行Delegate onStart函数
            if (this@activityScope.isNotAppCompat) delegateScope {
                onStart()
            }
        }

        /**
         * 活动恢复时执行
         */
        override fun onResume(owner: LifecycleOwner): Unit = activityScope {
            super.onResume(owner)
            // 执行Delegate onPostResume函数
            if (this@activityScope.isNotAppCompat) delegateScope {
                onPostResume()
            }
        }

        /**
         * 活动暂停时执行
         */
        override fun onPause(owner: LifecycleOwner): Unit = activityScope {
            super.onPause(owner)
        }

        /**
         * 活动停止时执行
         */
        override fun onStop(owner: LifecycleOwner): Unit = activityScope {
            super.onStop(owner)
            if (this@activityScope.isNotAppCompat) delegateScope {
                onStop()
            }
        }

        /**
         * 活动销毁时执行
         */
        override fun onDestroy(owner: LifecycleOwner): Unit = activityScope {
            super.onDestroy(owner)
            if (this@activityScope.isNotAppCompat) delegateScope {
                onDestroy()
            }
        }
    }

    /**
     ***********************************************************************************************
     * 分类: 调用单元
     ***********************************************************************************************
     */

    /**
     * 框架调用单元
     * Flutter插件调用框架
     * @param content Flutter插件代理单元
     * @return content 返回值
     */
    private fun <R> bridgeScope(
        content: FlutterPluginProxy.() -> R,
    ): R = content.invoke(
        mEngineBridge.run {
            return@run when (this@run) {
                is FlutterPluginProxy -> this@run
                else -> error(
                    message = "引擎桥接未实现插件代理方法"
                )
            }
        },
    )

    /**
     * 引擎调用单元
     * 框架调用引擎
     * @param content 引擎包装器单元
     * @return content 返回值
     */
    private fun <R> engineScope(
        content: EngineWrapper.() -> R,
    ): R = content.invoke(
        mFreeFEOSEngine.run {
            return@run when (this@run) {
                is EngineWrapper -> this@run
                else -> error(
                    message = "引擎未实现引擎包装器方法"
                )
            }
        },
    )

    /**
     * 生命周期调用单元
     * 调用生命周期所有者和生命周期观察者
     * @param content 生命周期包装器
     * @return content 返回值
     */
    private fun <R> lifecycleScope(
        content: LifecycleWrapper.() -> R
    ): R = content.invoke(
        mServiceDelegate.run {
            return@run when (this@run) {
                is LifecycleWrapper -> this@run
                else -> error(
                    message = "服务代理未实现生命周期包装器方法"
                )
            }
        },
    )

    /**
     * 插件调用单元
     * 插件初始化
     * @param context 上下文
     * @param content 插件列表单元, 插件绑定器
     * @return content 返回值
     */
    private fun <R> pluginScope(
        context: Context,
        debug: Boolean,
        content: (ArrayList<EmbedderPlugin>, PluginBinding) -> R,
    ): R = content.invoke(
        arrayListOf(
            mEngineBridge,
            mFreeFEOSEngine,
            mServiceInvoke,
            mServiceDelegate,
        ),
        PluginBinding(
            debug = debug,
            context = context,
            engine = mFreeFEOSEngine.run {
                return@run when (this@run) {
                    is EngineWrapper -> this@run
                    else -> error(
                        message = "引擎未实现引擎包装器方法"
                    )
                }
            },
        ),
    )

    /**
     * 客户端回调调用单元
     * 绑定解绑调用客户端回调
     * @param content 客户端回调单元
     * @return content 返回值
     */
    private fun <R> invokeScope(
        content: InvokeWrapper.() -> R,
    ): R = content.invoke(
        mServiceInvoke.run {
            return@run when (this@run) {
                is InvokeWrapper -> this@run
                else -> error(
                    message = "服务调用插件未实现客户端包装器方法"
                )
            }
        },
    )

    /**
     * 服务调用单元
     * 服务与服务嗲用
     * @param content 服务
     * @return content 返回值
     */
    private fun <R> serviceScope(
        content: DelegateWrapper.() -> R,
    ): R = content.invoke(
        mServiceDelegate.run {
            return@run when (this@run) {
                is DelegateWrapper -> this@run
                else -> error(
                    message = "服务代理未实现服务代理包装器方法"
                )
            }
        },
    )

    /**
     * 服务连接器调用单元
     * 调用服务连接包装器
     * @param content 服务链接包装器
     * @return content 返回值
     */
    private fun <R> connectScope(
        content: ConnectWrapper.() -> R,
    ): R = content.invoke(
        mServiceDelegate.run {
            return@run when (this@run) {
                is ConnectWrapper -> this@run
                else -> error(
                    message = "服务代理未实现连接包装器方法"
                )
            }
        },
    )

    /**
     * Shizuku方法调用单元
     * 添加与移除Shizuku监听
     * @param content Shizuku
     * @return content 返回值
     */
    private fun <R> shizukuScope(
        content: ShizukuWrapper.() -> R,
    ): R = content.invoke(
        mServiceDelegate.run {
            return@run when (this@run) {
                is ShizukuWrapper -> this@run
                else -> error(
                    message = "服务代理未实现Shizuku包装器方法"
                )
            }
        },
    )

    /**
     * AppCompat方法调用单元
     * 调用AppCompat包装器方法
     * @param content AppCompat
     * @return content 返回值
     */
    private fun <R> appCompatScope(
        content: AppCompatWrapper.() -> R,
    ): R = content.invoke(
        mServiceDelegate.run {
            return@run when (this@run) {
                is AppCompatWrapper -> this@run
                else -> error(
                    message = "服务代理未实现AppCompat包装器方法"
                )
            }
        },
    )

    /**
     * Activity上下文调用单元
     * Activity生命周期观察者通过此调用单元执行基于Activity上下文的代码
     * @param content 内容
     * @return content 返回值
     */
    private fun <R> activityScope(
        content: Activity.() -> R,
    ): R = content.invoke(
        mActivity ?: error(
            message = "activity is null"
        ),
    )

    /**
     * 委托函数调用单元
     * 调用委托
     * @param content 委托
     * @return content 返回值
     */
    private fun <R> delegateScope(
        content: AppCompatDelegate.() -> R
    ): R = content.invoke(mAppCompatDelegate)

    /**
     ***********************************************************************************************
     * 分类: 私有函数
     ***********************************************************************************************
     */

    /**
     * 扩展函数判断是否为空
     */
    private inline val Any?.isNull: Boolean
        get() = this@isNull == null

    /**
     * 扩展函数判断是否为空
     */
    private inline val Any?.isNotNull: Boolean
        get() = this@isNotNull != null

    /**
     * 判断当前Activity是否为AppCompatActivity
     */
    private inline val Activity.isAppCompat: Boolean
        get() = this@isAppCompat is AppCompatActivity

    /**
     * 判断当前Activity是否为AppCompatActivity
     */
    private inline val Activity.isNotAppCompat: Boolean
        get() = this@isNotAppCompat !is AppCompatActivity

    /**
     * 判断Activity是否为FlutterActivity或FlutterFragmentActivity
     */
    private inline val Activity.isFlutter: Boolean
        get() = (this@isFlutter is FlutterActivity) or (this@isFlutter is FlutterFragmentActivity)

    /**
     * 调用方法
     */
    private inline fun invokeMethod(block: () -> Unit): Boolean {
        try {
            block.invoke()
            return true
        } catch (e: Exception) {
            return false
        }
    }

    /**
     * 初始化
     */
    private fun init(onCreate: () -> Unit) = activityScope {
        // 初始化Delegate
        initDelegate()
        // 初始化工具栏状态
        isVisible = true
        // 判断Activity是否为AppCompatActivity
        if (this@activityScope.isNotAppCompat) delegateScope {
            // 为了保证接下来的Delegate调用，如果不是需要设置AppCompat主题
            initTheme()
            // 调用Delegate onCreate函数
            onCreate()
        }
        // 初始化用户界面
        initUi()
    }

    /**
     * 初始化委托
     */
    private fun initDelegate(): Unit = activityScope {
        // 初始化Delegate
        this@FreeFEOSEmbedder.mAppCompatDelegate = if (this@activityScope.isAppCompat) {
            (this@activityScope as AppCompatActivity).run {
                return@run this@run.delegate
            }
        } else {
            appCompatScope {
                return@appCompatScope AppCompatDelegate.create(
                    this@activityScope,
                    this@appCompatScope,
                )
            }
        }
        // 附加Delegate基本上下文
        if (this@activityScope.isNotAppCompat) serviceScope {
            attachDelegateBaseContext()
        }
    }

    /**
     * 初始化主题
     */
    private fun initTheme(): Unit = activityScope {
        val attributes: TypedArray = obtainStyledAttributes(
            androidx.appcompat.R.styleable.AppCompatTheme
        )
        if (!attributes.hasValue(androidx.appcompat.R.styleable.AppCompatTheme_windowActionBar)) {
            attributes.recycle()
            setTheme(androidx.appcompat.R.style.Theme_AppCompat_DayNight_NoActionBar)
        }
    }

    /**
     * 初始化用户界面
     */
    private fun initUi(): Unit = activityScope {
        // 初始化工具栏
        Toolbar(this@activityScope).apply {

            this@apply.setNavigationOnClickListener { view ->

            }
            this@FreeFEOSEmbedder.mToolbar = this@apply
        }
        // 初始化对话框
        AlertDialog.Builder(this@activityScope).apply {
            setTitle("Debug Menu (Native)")
            setItems(
                arrayOf(
                    "Launch Shizuku", "Launch microG", "Request Permissions"
                )
            ) { dialog, which ->
                when (which) {
                    0 -> if (AppUtils.isAppInstalled(FreeFEOSManifest.SHIZUKU_PACKAGE)) {
                        AppUtils.launchApp(FreeFEOSManifest.SHIZUKU_PACKAGE)
                    } else {
                        // 跳转安装
                    }

                    1 -> {
                        // 判断是否支持谷歌基础服务
                        if (isSupportGMS()) {
                            // 判断如果有启动图标直接打开 - 针对microG
                            if (IntentUtils.getLaunchAppIntent(FreeFEOSManifest.GMS_PACKAGE).isNotNull) {
                                AppUtils.launchApp(FreeFEOSManifest.GMS_PACKAGE)
                            } else {
                                // 如果没有启动图标使用包名和类名启动 - 针对谷歌GMS
                                val intent = IntentUtils.getComponentIntent(
                                    FreeFEOSManifest.GMS_PACKAGE,
                                    FreeFEOSManifest.GMS_CLASS,
                                )
                                if (IntentUtils.isIntentAvailable(intent)) {
                                    try {
                                        startActivity(intent)
                                    } catch (e: Exception) {
                                        // 启动失败
                                    }
                                } else {
                                    // 意图不可用
                                }
                            }
                        } else {
                            // 跳转安装microG
                        }

                        //gms(this@activityUnit)

                    }

                    2 -> {
                        requestPermissions()
                    }

                    else -> {}
                }
            }
            setView(this@FreeFEOSEmbedder.mToolbar)
            setPositiveButton(FreeFEOSResources.POSITIVE_BUTTON_STRING) { dialog, which -> }
            mDebugDialog = create()
        }
        // 设置操作栏
        delegateScope {
            // 仅在使用Flutter的Activity时设置ActionBar,防止影响混合应用的界面.
            if (this@activityScope.isFlutter) {
                setSupportActionBar(mToolbar)
            } else {
                mToolbar.setTitle(AppUtils.getAppName())
            }
        }
        // 设置根视图触摸事件
        findRootView()?.setOnTouchListener(delayHideTouchListener)
    }

    /**
     * 打开对话框
     */
    private fun openDialog() {
        if (!mDebugDialog.isShowing) {
            mDebugDialog.show()
        }
    }

    /**
     * 关闭对话框
     */
    private fun closeDialog() {
        if (mDebugDialog.isShowing) {
            mDebugDialog.dismiss()
        }
    }

    /**
     * 获取操作栏
     */
    private fun getActionBar(): ActionBar? = delegateScope {
        return@delegateScope supportActionBar
    }

    /**
     * 检查Shizuku权限
     */
    private fun checkShizukuPermission(): Boolean {
        return try {
            when {
                Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED -> true
                Shizuku.shouldShowRequestPermissionRationale() -> false
                else -> false
            }
        } catch (e: IllegalStateException) {
            false
        }


//        return if (Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED) {
//            // Granted
//            true
//        } else if (Shizuku.shouldShowRequestPermissionRationale()) {
//            // Users choose "Deny and don't ask again"
//            false
//        } else false
    }

    /**
     * 判断Shizuku是否已安装
     */
    private fun isShizukuInstalled(): Boolean {
        return if (AppUtils.isAppInstalled(FreeFEOSManifest.SHIZUKU_PACKAGE)) {
            !Shizuku.isPreV11()
        } else false
    }

    /**
     * 判断是否支持谷歌基础服务
     */
    private fun isSupportGMS(): Boolean = activityScope {
        return@activityScope if (GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(
                this@activityScope
            ) == ConnectionResult.SUCCESS
        ) true else AppUtils.isAppInstalled(
            FreeFEOSManifest.GMS_PACKAGE
        )
    }

    /**
     * 请求权限
     */
    private fun requestPermissions() {
        try {
            Shizuku.requestPermission(0)
            PermissionUtils.permission(FreeFEOSManifest.FAKE_PACKAGE_SIGNATURE).request()
        } catch (e: IllegalStateException) {

        }
    }

    /**
     * 获取根视图
     */
    private fun findRootView(): View? = activityScope {
        return@activityScope when (this@activityScope) {
            is FlutterActivity -> findFlutterView(
                view = window.decorView
            )

            else -> window.decorView
        }
    }

    /**
     * 获取FlutterView
     */
    private fun findFlutterView(view: View?): FlutterView? {
        when (view) {
            is FlutterView -> return view
            is ViewGroup -> for (index in 0 until view.childCount) {
                return findFlutterView(view.getChildAt(index))
            }
        }
        return null
    }

    /**
     * 绑定服务
     * @param context 上下文
     */
    private fun bindEmbedder(context: Context) = connectScope {
        try {
            if (!mIsBind) {
                context.bindService(
                    this@FreeFEOSEmbedder.mEmbedderServicesIntent,
                    this@connectScope,
                    Context.BIND_AUTO_CREATE,
                ).let { bind ->
                    invokeScope {
                        if (!bind) onEmbedderDead()
                    }
                }
            }
        } catch (e: Exception) {
            if (this@FreeFEOSEmbedder.mFullDebug) {
                Log.e(PLUGIN_TAG, "bindEmbedder", e)
            }
        }
    }

    /**
     * 解绑服务
     * @param context 上下文
     */
    private fun unbindEmbedder(context: Context) = connectScope {
        try {
            if (this@FreeFEOSEmbedder.mIsBind) {
                context.unbindService(
                    this@connectScope
                ).run {
                    this@FreeFEOSEmbedder.mIsBind = false
                    this@FreeFEOSEmbedder.mAIDL = null
                    invokeScope {
                        onEmbedderDisconnected()
                    }
                    if (this@FreeFEOSEmbedder.mFullDebug) {
                        Log.i(PLUGIN_TAG, "服务已断开连接 - onServiceDisconnected")
                    }
                }
            }
        } catch (e: Exception) {
            if (this@FreeFEOSEmbedder.mFullDebug) {
                Log.e(PLUGIN_TAG, "unbindEmbedder", e)
            }
        }
    }

    /**
     * 切换工具栏显示状态
     */
    private fun toggle() {
        if (this@FreeFEOSEmbedder.isVisible) hide() else show()
    }

    /**
     * 隐藏工具栏
     */
    private fun hide() {
        getActionBar()?.hide()
        this@FreeFEOSEmbedder.isVisible = false
        this@FreeFEOSEmbedder.hideHandler.removeCallbacks(showPart2Runnable)
    }

    /**
     * 显示工具栏
     */
    private fun show() {
        this@FreeFEOSEmbedder.isVisible = true
        this@FreeFEOSEmbedder.hideHandler.postDelayed(
            showPart2Runnable, UI_ANIMATOR_DELAY.toLong()
        )
    }

    /**
     * 延时隐藏
     */
    private fun delayedHide() {
        this@FreeFEOSEmbedder.hideHandler.removeCallbacks(hideRunnable)
        this@FreeFEOSEmbedder.hideHandler.postDelayed(
            hideRunnable, AUTO_HIDE_DELAY_MILLIS.toLong()
        )
    }

    private fun gms(context: Context) {
        try {
            val intent = Intent(Intent.ACTION_MAIN)
            intent.setPackage(FreeFEOSManifest.GMS_PACKAGE)
            try {
                context.startActivity(intent)
            } catch (e: Exception) {
                Log.w(PLUGIN_TAG, "MAIN activity is not DEFAULT. Trying to resolve instead.")
                intent.setClassName(
                    FreeFEOSManifest.GMS_PACKAGE,
                    packageManager.resolveActivity(intent, 0)!!.activityInfo.name
                )
                context.startActivity(intent)
            }
            Toast.makeText(context, "toast_installed", Toast.LENGTH_LONG).show()
        } catch (e: Exception) {
            Log.w(PLUGIN_TAG, "Failed launching microG Settings", e)
            Toast.makeText(context, "toast_not_installed", Toast.LENGTH_LONG).show()
        }

    }

    private fun shizukuVersion(): String {
        return try {
            "Shizuku ${Shizuku.getVersion()}"
        } catch (e: Exception) {
            Log.getStackTraceString(e)
        }
    }

    private fun getShizukuVersion(): String? {
        return try {
            if (this@FreeFEOSEmbedder.mIsBind) {
                if (this@FreeFEOSEmbedder.mAIDL != null) {
                    this@FreeFEOSEmbedder.mAIDL!!.shizukuVersion
                } else {
                    invokeScope {
                        onEmbedderUnbind()
                    }
                    null
                }
            } else {
                invokeScope {
                    onEmbedderUnbind()
                }
                null
            }
        } catch (e: Exception) {
            if (this@FreeFEOSEmbedder.mFullDebug) {
                Log.e(PLUGIN_TAG, "getShizukuVersion", e)
            }
            null
        }
    }

    /**
     * 资源
     */
    private object FreeFEOSResources {

        /** 开发者 */
        const val DEFAULT_AUTHOR: String = "wyq0918dev"

        /** 确定按钮文本 */
        const val POSITIVE_BUTTON_STRING: String = "确定"

    }

    /**
     * 清单
     */
    private object FreeFEOSManifest {
        /** 服务动作 */
        const val ACTION: String = "com.freefeos.freefeos.action"

        /** Shizuku包名 */
        const val SHIZUKU_PACKAGE: String = "moe.shizuku.privileged.api"

        /** 谷歌基础服务包名 */
        const val GMS_PACKAGE: String = "com.google.android.gms"

        const val GMS_CLASS: String = "com.google.android.gms.app.settings.GoogleSettingsLink"

        /** 签名伪装权限 */
        const val FAKE_PACKAGE_SIGNATURE: String = "android.permission.FAKE_PACKAGE_SIGNATURE"
    }

    /**
     * 通道
     */
    private object FreeFEOSChannel {
        /** Flutter插件通道名称 */
        const val FLUTTER_CHANNEL_NAME: String = "freefeos"

        /** 引擎桥梁插件 */
        const val BRIDGE_CHANNEL_NAME: String = "freefeos_bridge"

        /** 引擎 */
        const val ENGINE_CHANNEL_NAME: String = "freefeos_engine"

        /** 服务调用插件 */
        const val INVOKE_CHANNEL_NAME: String = "freefeos_invoke"

        /** 服务代理插件 */
        const val DELEGATE_CHANNEL_NAME: String = "freefeos_delegate"
    }

    /**
     * 方法
     */
    private object FreeFEOSMethod {
        /** 获取插件列表 */
        const val GET_PLUGINS_METHOD: String = "getPlugins"

        /** 打开对话框 */
        const val OPEN_DIALOG_METHOD: String = "openDialog"

        /** 关闭对话框 */
        const val CLOSE_DIALOG_METHOD: String = "closeDialog"
    }

    /**
     * 伴生对象
     */
    private companion object {
        /** 用于打印日志的标签 */
        const val PLUGIN_TAG: String = "FreeFEOSEmbedder"

        /** 操作栏是否应该在[AUTO_HIDE_DELAY_MILLIS]毫秒后自动隐藏。*/
        const val AUTO_HIDE: Boolean = false

        /** 如果设置了[AUTO_HIDE]，则在用户交互后隐藏操作栏之前等待的毫秒数。*/
        const val AUTO_HIDE_DELAY_MILLIS: Int = 3000

        /** 一些较老的设备需要在小部件更新和状态和导航栏更改之间有一个小的延迟。*/
        const val UI_ANIMATOR_DELAY: Int = 300
    }
}