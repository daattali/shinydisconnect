var disconDisplayed = false;

function showDiscon() {
  $('#ss-connect-dialog').show().addClass("shiny-discon");
  $('#ss-overlay').show();
}

$(document).on('shiny:disconnected', function(event) {
  showDiscon();
  disconDisplayed = true;
});

$(function(){
  let disconCheck;
  let num = 0;
  // 3s to check if shiny server is connected
  disconCheck = setInterval(function(){
    if(disconDisplayed === true) {clearInterval(disconCheck);}
    num += 1;
    // if timeout, delete checker, show discon message
    if(num >= 3) {
      clearInterval(disconCheck);
      showDiscon();
      $('#ss-connect-dialog')
        .removeClass('shiny-discon')
        .addClass("shiny-discon-noserver");
    }
    // if server detected, delete this checker
    if(typeof Shiny !== undefined){
      if(Shiny.shinyapp.$socket != null){
        if(Shiny.shinyapp.$socket.readyState === 1){
          clearInterval(disconCheck);
        }
      }
    }
  }, 1000);
});

// ws://127.0.0.1:6621/websocket/"
