import $ from "jquery"
import {Socket} from "phoenix"

let socket = new Socket("/socket")

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("cooler", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("state", resp => {
  console.log(resp);
  $("#cooler-view").html(resp.html);
})

$(() => {
  $("body").on("click", "#cooler-view", () => {
    channel.push("toggle")
  })
})

export default socket
