$(document).ready(function(e) {
  // ============ BTN ADD FRIEND
  function ajaxFriend(btnFriend, type, content, addClass, removeClass) {
    btnFriend.prop('disabled', true);
    var userId = btnFriend.attr('data-user');
    var friendId = btnFriend.attr('data-id');
    var data = {
      user_id: userId,
      friend_id: friendId,
      type: type
    }
    var url = '/api/v1/users/add_remove_friend';
    $.ajax({
      url: url,
      type: "post",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      },
      data: JSON.stringify(data)
    })
    .done(function(xhr) {
      console.log(xhr);
      if(xhr.ok) {
        btnFriend.html('<p>' + content + '</p>');
        btnFriend.removeClass(removeClass);
        btnFriend.addClass(addClass);
      }
    })
    .fail(function(error) {
      console.log(error);
    })
    .always(function(){
      btnFriend.prop('disabled', false);
    });
  }
  //add
  $('#users').on('click', '.btn-friend-add', function(e) {
    var btnFriend = $(this);
    e.preventDefault();
    ajaxFriend(btnFriend, 1, 'Remove', 'btn-friend-remove', 'btn-friend-add');
  });
  //remove
  $('#users').on('click', '.btn-friend-remove', function(e) {
    var btnFriend = $(this);
    e.preventDefault();
    ajaxFriend(btnFriend, 0, 'Add', 'btn-friend-add', 'btn-friend-remove');
  });
  // ============ END BTN ADD FRIEND

  // ============ update read message

  function handleReceiveUnread(li) {
    var data = {
      uid: li.attr('data-uid'),
      user_id: li.attr('data-user-id')
    }
    var message_id = li.attr('data-message-id');
    var url = `/messages/${message_id}/update_read`;
    $.ajax({
      url: url,
      type: 'post',
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    })
    .done(function(xhr) {
      if(xhr.ok) {
        li.removeClass("message-unread");
        $("#label-message-modal").html("From");
        $("#r-status-" + xhr.message.id).html('<i class="fa fa-envelope-open-o" aria-hidden="true"></i>');
        $("#read-message-modal #send-from").val(xhr.message.sender);
        $("#read-message-modal #message-from").html('from ' + xhr.message.sender);

        $("#read-message-modal #send-from-time").val(xhr.message.sent_ago);
        $("#read-message-modal .note-editable.panel-body").html(xhr.message.content);

        $("#read-message-modal").modal();
      }
    })
    .fail(function(error) {
      console.log(error);
    });
  }

  $(".list-messages").on('click', '.message-receive', function(e) {
    var read = $(this).attr("data-read") == 'true' ? true : false;
    if(read) { console.log(1); return }
    handleReceiveUnread($(this));
  });
  // ============ end update read message

  // send message

  $(".list-messages").on('click', '.message-send', function(e) {
    var li = $(this);
    var message_id = li.attr('data-message-id');
    var url = `/messages/${message_id}/message`;
    $.ajax({
      url: url,
      type: "get",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    })
    .done(function(xhr) {
      if(xhr.ok) {
        $("#label-message-modal").html("To");
        $("#read-message-modal #send-from").val(xhr.message.receiver);
        $("#read-message-modal #message-from").html('to ' + xhr.message.receiver);

        $("#read-message-modal #send-from-time").val(xhr.message.sent_ago);
        $("#read-message-modal .note-editable.panel-body").html(xhr.message.content);

        $("#read-message-modal").modal();
      }
    })
    .fail(function(error) {
      console.log(error);
    });
  });

  // end send message

  // ============ get all friend
  $("#btn-compose-message").on('click', function(e) {
    selectize.clearOptions();
    var user_id = $(this).attr('data-user-id');
    var url = `/api/v1/users/${user_id}/get_all_friends`;
    $.ajax({
      url: url,
      type: "get",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    })
    .done(function(xhr){
      console.log(xhr);
      if(xhr.ok) {
        var options = [];
        var users = xhr.message;
        selectize.addOption(users);
      }
    })
    .fail(function(error) {
      console.log(error);
    })
    .always(function(){
    });
  });
  // ============ end get all friend

  // ============ send

  $("#btn-send-message-users").on("click", function(e) {
    e.preventDefault();
    debugger
    var input = selectize.getValue();
    var divContent = $('.note-editable.panel-body');
    content = divContent.html().trim();
    var errors = $("#erorrs-modal");
    if(input != "" && content != "") {
      var arrInput = input.split(",");
      var data = {
        users: arrInput,
        content: content
      }
      $.ajax({
        url: 'messages/send_message',
        type: "post",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json"
        },
        data: JSON.stringify(data)
      })
      .done(function(xhr){
        console.log(xhr);
        if(xhr.ok) {
          errors.show();
          errors.css("color", "#5cb85c");
          errors.html("Message send successfully");
          divContent.html("");
          selectize.clear();
        } else {
          errors.show();
          errors.css("color", "red");
          errors.html("Error while send message, please reload page or press F5");
        }
      })
      .fail(function(error) {
        console.log(error);
      });
    } else {
      errors.show();
      errors.css("color", "red");
      errors.html("Please enter two inputs");
    }

    setTimeout(function(e) {
      errors.fadeOut();
    }, 2000);
  });

  //  ============ end send messages

  // sync message
  $("#btn-sync").click(function(e) {
    var btn = $(this);
    btn.html('<img src="images/load.gif">');
    $.ajax({
      url: 'messages/get_all_receive_message',
      type: "post",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    })
    .done(function(xhr){
      console.log(xhr);
      if(xhr.ok) {
        var messages = xhr.messages;
        var l = messages.length;
        var ul = $("#list-r-messages");
        ul.html("");
        for(var i = 0 ; i < l ; i++) {
          ul.append(createLi(messages[i]));
        }
      }
    })
    .fail(function(error) {
      console.log(error);
    })
    .always(function(){
      btn.html('<i class="fa fa-refresh" aria-hidden="true"></i>');
    });
  });

  function createLi(message) {
    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    var unread = message.read == 0 ? 'message-unread' : '';
    var date = new Date(message.time);
    var d = date.getDate();
    var m = monthNames[date.getMonth()];
    var readDate = new Date(message.uid);
    var timeAgo = jQuery.timeago(message.uid);
    var content = jQuery.truncate(message.message, {
      length: 300,
      stripTags: true
    });
    var li = $(`<li class="message message-receive ${unread}" data-uid="${message.uid}" data-user-id="${message.sUser}" data-user-name="${message.sName}" data-receive-time="${readDate}"></li>`);
    var div = (`<div class="date"><span>${d}</span><span class="small">${m}</span></div>`);
    var pTitle = $(`<p class="message-title">From ${message.sName}&nbsp;<span class="status" id="r-status-${message.uid}"><i class="fa fa-envelope-open-o" aria-hidden="true"></i></span>&nbsp;<time class="timeago" datetime="${readDate}" title="${readDate}">${timeAgo} </time>&bull;&nbsp;<i class="fa fa-globe" aria-hidden="true"></i></p>`)
    var pContent = $(`<p class="message-content">${content}</p>`)
    li.append(div);
    li.append(pTitle);
    li.append(pContent);
    return li;
  }

  // end sync message
});
