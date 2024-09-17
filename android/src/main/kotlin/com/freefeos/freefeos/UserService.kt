package com.freefeos.freefeos

import android.util.Log
import kotlin.system.exitProcess

class UserService : IUserService.Stub() {

    /**
     * ShizukuAPI内置方法
     */
    override fun destroy() = exitProcess(status = 0)

    /**
     * ShizukuAPI内置方法
     */
    override fun exit() = exitProcess(status = 0)

    override fun poem() {
        Log.d("", "Shizuku - poem")
    }
}