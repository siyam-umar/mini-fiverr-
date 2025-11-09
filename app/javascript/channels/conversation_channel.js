
import consumer from "./consumer"

function mountConversationChannel() {
  const list = document.getElementById("messages")
  if (!list) return

  const conversationId = list.dataset.conversationId

  consumer.subscriptions.create(
    { channel: "ConversationChannel", conversation_id: conversationId },
    {
      connected() {
        // console.log("Connected to conversation", conversationId)
      },
      disconnected() {},
      received(data) {
        if (data.type === "message" && data.html) {
          list.insertAdjacentHTML("beforeend", data.html)
          list.lastElementChild?.scrollIntoView({ behavior: "smooth", block: "end" })
        }
      }
    }
  )
}

// Support Turbo navigation
document.addEventListener("turbo:load", mountConversationChannel)
document.addEventListener("turbo:render", mountConversationChannel)


