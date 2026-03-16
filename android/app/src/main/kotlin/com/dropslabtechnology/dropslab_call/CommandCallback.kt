package com.dropslabtechnology.dropslab_call

interface CommandCallback {
    fun getCommandSlot(cmd: String?)
    fun getSpeechSlot(cmd: String?)
}
