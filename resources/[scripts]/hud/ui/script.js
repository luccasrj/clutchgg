$("#Body").hide()
$(document).ready(function(){
  var $heal = $("#armor");
  var $box = $("#box");
  var $boxArmor = $("#heal");
  window.addEventListener('message', function(event){
     if ( event.data.display == true ) {
      $('#hud').fadeIn(500);
      $('.mic').html(event.data.voz)
	  $('.street').html("<strong id='rua'>"+event.data.street+"</strong>")
      $('.info').html("<strong id='time'>"+ event.data.hora +":"+ event.data.minuto +"</strong>")
    }
    if ( event.data.incar == true ) {
      $('.info').css('right','305px'); 
      $('.hud-player').css('background','url(img/health-progessbar.png) no-repeat');
      $('.hud-player').css('width','220px');
      $('.hud-player').hide();
      $('#mic').fadeIn(500);
      $(".hud-car").fadeIn(500);
      $('.hud-player').fadeIn(1000);
	  
    }   
    else {
      $('#mic-text').css('left','-5px'); 
      $('.info').css('right','50px'); 
      $('.hud-player').css('background','url(img/bg-health.png) no-repeat');
      $('.hud-player').css('width','220px');
      $('.hud-player').css('right','5px');
      $(".hud-car").fadeOut(500);
    }
    if ( event.data.cinto == true ) {
      $("#cinto").addClass("on");
      $("#cinto").removeClass("off");
    }   
    else {
      $("#cinto").addClass("off");
      $("#cinto").removeClass("on");
    }
    if ( event.data.farol == 0 ) {
      $('.lights-indicator').css('background-image', 'url(img/farol.png)');   
    }   
     if ( event.data.farol == 1 ) {
      $('.lights-indicator').css('background-image', 'url(img/farol-on-baixo.png)');   
    }   
    if ( event.data.farol == 2 ) {
     
      $('.lights-indicator').css('background-image', 'url(img/farol-on.png)');   
    }   
   
    if ( event.data.piscaEsquerdo == true && event.data.piscaDireito == false) {
      $('.seta-esq-indicator').removeClass('off');
      $('.seta-esq-indicator').addClass('on');
      $('.seta-esq-indicator').addClass('active');
 
    } 
    if ( event.data.piscaEsquerdo == false) {
      $('.seta-esq-indicator').removeClass(' on');
      $('.seta-esq-indicator').addClass('off');
      $('.seta-esq-indicator').removeClass('active');
    } 
    if ( event.data.piscaDireito == true &&  event.data.piscaEsquerdo == false ) {
      $('.seta-dir-indicator').removeClass('off');
      $('.seta-dir-indicator').addClass('on');
      $('.seta-dir-indicator').addClass('active');
      
    } 
	
    if ( event.data.piscaDireito == false) {
      $('.seta-dir-indicator').removeClass('off');
      $('.seta-dir-indicator').addClass('off');
      $('.seta-dir-indicator').removeClass('active');
      
    } 
    if ( event.data.piscaDireito == true && event.data.piscaEsquerdo == true ) {
    
      $('.seta-dir-indicator').removeClass('off');
      $('.seta-esq-indicator').removeClass('off');
      $('.seta-dir-indicator').removeClass('active');
      $('.seta-esq-indicator').removeClass('active');
      $('.seta-esq-indicator').addClass('on');
      $('.seta-dir-indicator').addClass('on');
      $('.seta-indicator').addClass('active');
    } 
    if ( event.data.piscaDireito == false && event.data.piscaEsquerdo == false ) {
      $('.seta-dir-indicator').removeClass('on');
      $('.seta-esq-indicator').removeClass('on');
      $('.seta-dir-indicator').addClass('off');
      $('.seta-esq-indicator').addClass('off');
      $('.seta-indicator').removeClass('active');
    
    }      
    $("#rpm").css("background-image",'url("img/gauge/gauge-' + event.data.rpm + '.png")');
  
    $("#speed").html(event.data.speed);
  
    
    if(event.data.gear >= 5 ){
      $("#gear5").addClass('gearActive');  
    }else{
      $("#gear5").removeClass('gearActive');
      $('#current-shift').html(event.data.gear)
    }
    if(event.data.gear != 1 ){$("#gear1").removeClass('gearActive')};
    if(event.data.gear != 2 ){$("#gear2").removeClass('gearActive')};
    if(event.data.gear != 3 ){$("#gear3").removeClass('gearActive')};
    if(event.data.gear != 4 ){$("#gear4").removeClass('gearActive')};
    
    if(event.data.gear != "R" ){$("#gearR").removeClass('gearActive')};
    
    
	$(".probar").css("height", 100 - event.data.fome + "%");
	$(".probar2").css("height", 100 - event.data.sede + "%");
	
	
    $boxArmor.css("width", (event.data.armor)+"%");
    $heal.css("width", (event.data.heal)+"%");
    $('.circle_path').attr('stroke-dasharray', (event.data.armor)+",100");
    $('.circle_path2').attr('stroke-dasharray', (event.data.heal)+",100");
    if ( event.data.engine > 5 ){
      $(".vehicle-engine-level").css("height", (event.data.engine)+"%");
      $(".vehicle-engine-level").removeClass("low"); 
    }
    else {
      $(".vehicle-engine-level").css("height", (event.data.engine)+"%");
      $(".vehicle-engine-level").addClass("low"); 
    }
  })
});
window.addEventListener('message', function(event){
  let data = event.data;
  switch (data.action) {
      case "showServer":
        $(".server").show()
      break
      case "hideServer":
        $(".server").hide()
      break
      case "Weapons":
        if (data.Status){
          if ($("#NaviWeapons").css("display") === "none"){
            $("#NaviWeapons").fadeIn(250);
            $("#Body").show()
          }
          $(".NameAmmos").show()
          $(".NameWeapon").html(data.Name);
          if (data.Name != "FACA" && data.Name != "SOCO") {
            $(".NameAmmos").html(data.Min + " / " + data.Max);
          } else {
            $(".NameAmmos").hide()
          }

        } else {
          if ($("#NaviWeapons").css("display") === "block"){
            $("#NaviWeapons").fadeOut(250);
            $(".NameAmmos").hide()
            $("#Body").hide()
          }
        }
      break;
    }
})