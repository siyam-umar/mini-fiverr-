// Import all the channels to be used by Action Cable
import "channels/conversation_channel"
// auto-require all channels
const channels = import.meta.globEager("./*.js")
