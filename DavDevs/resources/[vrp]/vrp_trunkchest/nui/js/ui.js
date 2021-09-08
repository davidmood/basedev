(function ($) {
  $.fn.inputFilter = function (inputFilter) {
    return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function () {
      if (inputFilter(this.value)) {
        this.oldValue = this.value;
        this.oldSelectionStart = this.selectionStart;
        this.oldSelectionEnd = this.selectionEnd;
      } else if (this.hasOwnProperty("oldValue")) {
        this.value = this.oldValue;
        this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
      }
    });
  };
}(jQuery));

/*$(document).on('contextmenu', function(event) {
    event.preventDefault();
});*/
async function verifyConnection() {
  return navigator.onLine
}

function clearInputs() {
  $("#items-in").val('');
  $("#items-out").val('');
}


window.lastEvent = "hideMenu";
$(document).ready(function () {
  var actionContainer = $(".inventory-mask, .inventory-content");
  window.addEventListener("message", function (event) {
    var item = event.data;
    lastEvent = item.action;
    switch (item.action) {
      case "showMenu":
        updateMochila();
        $('#wrapper').addClass('active');
        actionContainer.fadeIn(500);
        break;

      case "hideMenu":
        $('#wrapper').removeClass('active');
        actionContainer.fadeOut(500);
        break;

      case "updateMochila":
        updateMochila();
        break;
    }
  });

  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post("http://vrp_trunkchest/invClose", JSON.stringify({}), function (datab) { });
    }
  };


  $(".single.in").click(function () {
    const itemsOut = $("#items-out").val();
    console.log('IN: ', itemsOut)
    const amount = $('#quant').val();
    if (itemsOut) {
      const parse = JSON.parse(itemsOut).items[0];
      if (parse) {
        verifyConnection()
        .then(success => {
        if (success) {
            clearInputs()
            $.post(
              "http://vrp_trunkchest/storeItem",
              JSON.stringify({
                item: parse,
                amount: parseFloat(amount),
                send: true
              })
            );
            }
          })
      }
    }
  });


  $(".single.out").click(function () {
    const itemsIn = $("#items-in").val();
    const amount = $('#quant').val();
    if (itemsIn) {
      const parse = JSON.parse(itemsIn).items[0];
      if (parse) {
        verifyConnection()
        .then(success => {
        if (success) {
            clearInputs()
            $.post(
              "http://vrp_trunkchest/takeItem",
              JSON.stringify({
                item: parse,
                amount: parseFloat(amount),
                send: true
              })
            );
          }
        })
      }
    }
  });

  $(".mutiple.in").click(async function () {
    const itemsOut = $("#items-out").val();
    if (itemsOut) {
      verifyConnection()
      .then(async success => {
      if (success) {
          const parse = JSON.parse(itemsOut).items;
          await $.post("http://vrp_trunkchest/bulkItems", JSON.stringify({ items: parse, take: false }),
            data => {
              clearInputs();
            }
          );
        }
      })
    }
  });


  $(".mutiple.out").click(async function () {
    const itemsIn = $("#items-in").val();
    verifyConnection()
    .then(async success => {
    if (success) {
        if (itemsIn) {
          const parse = JSON.parse(itemsIn).items;
          await $.post("http://vrp_trunkchest/bulkItems", JSON.stringify({ items: parse, take: true }),
            data => {          
              clearInputs();
            }
          );
        }
      }
    })
  });
});

var requestAjax = (option, itemKey, amount) => {
  $.post(
    "http://vrp_trunkchest/" + option,
    JSON.stringify({
      item: itemKey,
      amount
    })
  );
}

var templateTrunkChest = (key, amount, image, name, weight, target) => {

  return `
    <div class="item" data-item-key="${key}">
      <div class="item-container">
        <figure>
          <img src="http://149.56.80.90/vrp_itens/${image}.png" />
        </figure>
        <span class="amount">${formatarNumero(amount)}</span>
        <div class="name">${name}</div>
      </div>
    </div>
  `
}

const formatarNumero = n => {
  var n = n.toString();
  var r = "";
  var x = 0;

  for (var i = n.length; i > 0; i--) {
    r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? "." : "");
    x = x == 2 ? 0 : x + 1;
  }

  return r.split("").reverse().join("");
};

const updateMochila = () => {

  $.post("http://vrp_trunkchest/requestMochila", JSON.stringify({}), data => {
    const nameList = data.inventario.sort((a, b) => a.name > b.name ? 1 : -1);
    const nameList2 = data.inventario2.sort((a, b) => a.name > b.name ? 1 : -1);
    $('.bag-workspace > .inventory-title').html(`
      INVENTÁRIO <small>| EM USO: <b>${data.peso.toFixed(2)}KG</b> | DISPONIVEL: <b>${(data.maxpeso - data.peso).toFixed(2)}KG</b> | TAMANHO: <b>${data.maxpeso.toFixed(2)}KG</b></small>
    `);
    $('.trunk-workspace > .inventory-title').html(`
      BAÚ <small>| EM USO: <b>${data.peso2.toFixed(2)}KG</b> | DISPONÍVEL: <b>${(data.maxpeso2 - data.peso2).toFixed(2)}KG </b> | TAMANHO: <b>${data.maxpeso2.toFixed(2)}KG</b></small>
    `);
    var inventory = nameList.map(
      item => templateTrunkChest(item.key, item.amount, item.index, item.name, item.peso, 'trunk')
    ).join("");
    var trunkchest = nameList2.map(
      item => templateTrunkChest(item.key, item.amount, item.index, item.name, item.peso, 'inventory')
    ).join("");

    $("#out").html(trunkchest);
    $("#in").html(inventory);


    $("#weight1").html(`${data.peso.toFixed(2)}kg / <span style="color: orange">${data.maxpeso}kg</span>`)
    $("#weight2").html(`${data.peso2.toFixed(2)}kg / <span style="color: orange">${data.maxpeso2}kg</span>`)



    // Select Out
    $("#out .item").click(function () {
      const values = $("#items-out").val();
      const key = $(this).data('item-key');
      let data = {
        items: []
      };

      if (values) {
        data = JSON.parse(values);
      }


      if ($(this).hasClass('active')) {
        data.items = data.items.filter(item => item !== key);
        $(this).removeClass('active');


        if (data.items.length > 1) {
          $(".single").attr('disabled', true);
          $(".formgroup").addClass('hiden');
        } else {
          $(".single").attr('disabled', false);
          $(".formgroup").removeClass('hiden');
        }

        return $("#items-out").val(JSON.stringify(data));
      }

      $(this).addClass('active');
      data.items.push(key)


      if (data.items.length > 1) {
        $(".single").attr('disabled', true);
        $(".formgroup").addClass('hiden');
      } else {
        $(".single").attr('disabled', false);
        $(".formgroup").removeClass('hiden');
      }
      return $("#items-out").val(JSON.stringify(data));


    })




    // Select In
    $("#in .item").click(function () {
      const values = $("#items-in").val();
      const key = $(this).data('item-key');
      let data = {
        items: []
      };

      if (values) {
        data = JSON.parse(values);
      }


      if ($(this).hasClass('active')) {
        data.items = data.items.filter(item => item !== key);
        $(this).removeClass('active');


        if (data.items.length > 1) {
          $(".single").attr('disabled', true);
          $(".formgroup").addClass('hiden');
        } else {
          $(".single").attr('disabled', false);
          $(".formgroup").removeClass('hiden');
        }

        return $("#items-in").val(JSON.stringify(data));
      }

      $(this).addClass('active');
      data.items.push(key)


      if (data.items.length > 1) {
        $(".single").attr('disabled', true);
        $(".formgroup").addClass('hiden');
      } else {
        $(".single").attr('disabled', false);
        $(".formgroup").removeClass('hiden');
      }
      return $("#items-in").val(JSON.stringify(data));


    })
  });
};

$(document).ready(function () {
  $(document).on('mousedown', '.objects .cell', function (ev) {
    if (ev.which == 3) {
      $('.amount-option').hide();
      $(this).find('.amount-option').show();
    }
  });

  $('body').on('click', function (e) {
    if (!$(e.target).is(".objects .cell").length) {
      $(".cell .options").hide();
    }
  });

  $(document).on('click', '.amount-option button', function () {
    var event = $(this).data('event');
    if (event == 'send') {
      verifyConnection()
      .then(success => {
      if (success) {
          var paramUrl = $(this).data('url');
          var $el = $(this).closest('.cell');
          var amount = Number($el.find(".amount-value").val());
          if (!amount || amount == '') {
            amount = 0;
          }

          $.post(
            "http://vrp_trunkchest/" + paramUrl,
            JSON.stringify({
              item: $el.data("item-key"),
              amount
            })
          );
       }
      })
    }


    Option = false;

    $('.amount-option').hide();
  });
});

$(".amount-option .center input").on('focusout blur', function () {
  if ($(this).val() < 0) {
    $(this).val('0');
  }
}).inputFilter(function (value) {
  return /^\d*$/.test(value);
});

$(".amount-option .left").on('click', function () {
  var amountVal = $(this).closest('.cell').find(".amount-option .center input");
  if ((parseInt(amountVal.val()) - 1) >= 0) {
    amountVal.val(parseInt(amountVal.val()) - 1);
  }
});

$(".amount-option .right").on('click', function () {
  var amountVal = $(this).closest('.cell').find(".amount-option .center input");
  amountVal.val(parseInt(amountVal.val()) + 1);
});