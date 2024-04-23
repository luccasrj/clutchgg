let maxText = null;
let noList = null;
let count = 0;

$(document).ready(() => {
  window.addEventListener("message", (event) => {
    switch (event.data.action) {
      case "openSystem":
        app.open();
        app.createCharacter();
      break;
    }
  });
});

const app = {
  open: () => {
    $('body').show();
  },
  close: () => {
    $('body').hide();
  },
  createCharacter: () => {
    $('.sexOption').on('click', function() {
      $(".sexOption").removeClass('active');
      $(this).addClass('active');
    });
    let options = {
      method: 'POST',
      body: JSON.stringify({})
    }
    fetch('http://characters/deletePed', options) // Quando o personagem é selecionado
    $('footer').hide();
    $('.characterForm').fadeIn();
  },
  selectedSex: (sex) => {
    let options = {
      method: 'POST',
      body: JSON.stringify({ sex: sex })
    }
    fetch('http://characters/createSimplePed', options) // Quando o sexo do personagem é selecionado
  },
  characterSelect: (e) => {
    if ( maxText < 4 ) { 
      $(`.characterItem:nth-child(n+${maxText+1})`).prop('disabled', true);
      $(`.characterItem:nth-child(n+${maxText+1})`).removeClass('characterCheck');
      $(`.characterItem:nth-child(n+${maxText+1})`).html(`
          <span>Slot <b>bloqueado</b></span>
          <div class="infos">
            <div class="item-info">sem espaço</div>
          </div>
        </div>
      `);
    } 

    $('.characterCheck').find('.check').remove();
    $('.characterCheck').removeClass('active');
    $('.characterCheck').prop('disabled', false);
    $(e).append('<div class="check"><i class="fa-solid fa-check"></i></div>');
    $(e).prop('disabled', true);
    $(e).addClass('active');
    let userId = $(e).find('b').html().substring(1);

    let options = {
      method: 'POST',
      body: JSON.stringify({ id: parseInt(userId) })
    }
    fetch('http://characters/characterSelected', options) // Quando o personagem é selecionado
  },
  confirmForm: () => {
    let inputsValues = $('.input-content input').val();
    
    if (inputsValues == '') return;
    if (!$('.sexOption').hasClass('active')) return;
    if ($('#surname').val() == "") return;

    let formResult = {
      surname: $('#surname').val(),
      gender: $('.sexOpt .active').attr('data-id')
    }

    let options = {
      method: 'POST',
      body: JSON.stringify({ result: formResult })
    }
    
    fetch('http://characters/createCharacter', options).then(resp => resp.json().then(data => {
      if (data.sucess)  {
        $("body").hide();
      }
    }))
  },
  cancelForm: () => {
    $('.form-content').hide();
    $('footer').show();
    $('.input-content input').val('');
    $(".sexOption").removeClass('active');
    $('.characterItem:nth-child(1)').click();
  },
  playGame: () => {
    $('footer').hide();
    app.spawnCharacter();
  },
  spawnCharacter: (ev) => {
    let userId = $('.charactersContent .active').find('b').html().substring(1);
 
    let options = {
      method: 'POST',
      body: JSON.stringify({ userId: parseInt(userId) })
    }
    $("body").hide();
    fetch('http://characters/spawnCharacter', options).then(resp => resp.json().then(data => {
      if (data.error)  {
        
      }
    }))
  },
};

$('input').keyup(function() {
  if ($(this).val() == '') {
    $(this).parent().find('.check').fadeOut();
  } else {
    $(this).parent().find('.check').fadeIn();
  }
});