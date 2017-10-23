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
        li.attr("data-read", true);
      }
    })
    .fail(function(error) {
      console.log(error);
    });
  }

  $(".list-messages").on('click', '.message-receive', function(e) {
    var read = $(this).attr("data-read") == 'true' ? true : false;
    if(read) { 
      toastr['error']("This message has already read");
      return;
    }
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
          var ul = $("#list-s-messages");
          for(var index in xhr.message) {
            var message = xhr.message[index];
            var html_build = createSendMessage(message);
            ul.prepend($(html_build));
          }

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
    btn.html('<img src="https://easeofdoingbusinessinassam.in/images/loading.gif">');
    $.ajax({
      url: 'messages/get_all_receive_message',
      type: "get",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json"
      }
    })
    .done(function(xhr){
      console.log(xhr);
      if(xhr.ok) {
        var rul = $("#list-r-messages");
        var sul = $("#list-s-messages");
        rul.html("");
        sul.html("");
        var received_messages = xhr.message.received_messages;
        var sent_messages = xhr.message.sent_messages;
        for(var index in received_messages) {
          var message = received_messages[index];
          var html_build = createReceivedMessage(message);
          rul.append($(html_build));
        }
        debugger
        for(var index in sent_messages) {
          var message = sent_messages[index];
          var html_build = createSendMessage(message);
          sul.append($(html_build));
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

  function createReceivedMessage(message) {
    var read_class = message.read ? '' : 'message-unread';
    var evelop_icon = message.read ? '<i aria-hidden="true" class="fa fa-envelope-open-o"></i>' : '<i aria-hidden="true" class="fa fa-envelope-o"></i>';
    return ` <li class="message message-receive ${read_class}" data-message-id="${message.id}" data-read="${message.read}">
              <div class="date">
                <span> ${message.day} </span>
                <span class="small"> ${message.month} </span>
              </div>
              <p class="message-title">
                From ${message.sender}
                <span class="status" id="r-status-${message.id}">
                  ${evelop_icon}
                </span>
                <time> ${message.time_ago} </time>
                <i aria-hidden="true" class="fa fa-globe"></i>
              </p>
              <div class="message-content">
                ${message.content}
              </div>
            </li>`;
  }

  function createSendMessage(message) {
    var read_class = message.read ? '' : 'message-unread';
    var evelop_icon = message.read ? '<i aria-hidden="true" class="fa fa-envelope-open-o"></i>' : '<i aria-hidden="true" class="fa fa-envelope-o"></i>';
    var time = message.read ? `&bull; Seen <time> ${message.read_ago} </time>` : '';
    return `<li class="message message-send ${read_class}" data-message-id="${message.id}" data-read="${message.read}">
              <div class="date">
                <span>
                  ${message.day}
                </span>
                <span class="small">
                  ${message.month}
                </span>
              </div>
              <p class="message-title">
                To ${message.receiver}
                <span class="status">
                  ${evelop_icon}
                </span>
                <time>
                  ${message.time}
                </time>
                ${time}
                <i aria-hidden="true" class="fa fa-globe"></i>
              </p>
              <div class="message-content">
                ${message.content}
              </div>
            </li>`;
  }

  // end sync message
});
