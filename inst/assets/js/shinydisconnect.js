function showDiscon() {
  $('#ss-connect-dialog').show().addClass("shiny-discon");
  $('#ss-overlay').show();
}

$(document).on('shiny:disconnected', function(event) {
  showDiscon();
});

$(document).ready(function(){
  let disconCheck;
  let num = 0;
  // 3s to check if shiny server is connected
  disconCheck = setInterval(function(){
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
        if(Shiny.shinyapp.$socket.readyState === 1){
          clearInterval(disconCheck);
        }
    }
  }, 1000);
});
