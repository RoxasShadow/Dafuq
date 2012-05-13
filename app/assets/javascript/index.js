$(document).ready(function() {

	post = new Post();
	comment = new Comment();
	csrf = $('[name="_csrf"]').val();
	refresh();

	function auth() {
		if($('#post_username').val() == '' && $.cookie('username') != null)
			$('#post_username').val($.cookie('username'));
		if($('#username').val() == '' && $.cookie('username') != null)
			$('#username').val($.cookie('username'));
	}
	
	function refresh() {
		post.get(undefined, postsHandler);
		comment.get(undefined, commentsHandler);
		auth();
	}
	
	function report(text) {
		$('#notice').fadeIn('slow');
		$('#notice').attr('class', (text == Status.OK) ? 'good' : 'bad').html(text);
		setTimeout("$('#notice').fadeOut('slow');", 5000);
	}
	
	function postsHandler(data) {
		$('#posts').html('');
		if(data == undefined)
			return;
		for(i=0, len=data.length; i<len; ++i) {
			if(data[i] == undefined || data[i].username == undefined)
				continue;
			date = $.format.date(data[i].created_at, 'MM/dd/yyyy') + ' at ' + $.format.date(data[i].created_at, 'HH:mm:ss');
			$('#posts').append('<article id="post_'+data[i].id+'" class="post"><header>Written by '+data[i].username+' the <time pubdate datetime="'+data[i].created_at+'">'+date+'</time></header><p>'+data[i].text+'</p><footer><a class="replyPost" id="replyPost_'+data[i].id+'">Reply</a> | <a class="deletePost" id="deletePost_'+data[i].id+'">Delete</a> | <a class="editPost" id="editPost_'+data[i].id+'">Edit</a></footer></article>');
		}
	}
	
	$('.replyPost').live('click', function() {
		id = $(this).attr('id').replace('replyPost_', '');
		$('#post_id').val(id);
		$('#dialog_form').attr('title', 'Reply').dialog('open');
	});
	
	$('#dialog:ui-dialog').dialog('destroy');
	$('#dialog_form').dialog({
		autoOpen: false,
		width: 350,
		modal: true,
		buttons: {
			"Send comment": function() {
				item = $(this);
				id = $('#post_id').val();
				username = item.parent().find('#username').val();
				text = item.parent().find('#text').val();
				comment.create(id, username, text, csrf, report);
				refresh();
				item.dialog('close');
			},
			Cancel: function() {
				$(this).dialog('close');
			}
		},
		close: function() {
			$('#username').val('');
			$('#text').val('');
			auth();
		}
	});
	
	function commentsHandler(data) {
		if(data == undefined)
			return;
		for(i=0, len=data.length; i<len; ++i) {
			if(data[i] == undefined || data[i].username == undefined)
				continue;
			date = $.format.date(data[i].created_at, 'MM/dd/yyyy') + ' at ' + $.format.date(data[i].created_at, 'HH:mm:ss');
			$('#post_'+data[i].post_id).append('<article id="comment_'+data[i].id+'" class="comment"><header>Written by '+data[i].username+' the <time pubdate datetime="'+data[i].created_at+'">'+date+'</time></header><p>'+data[i].text+'</p><footer><a class="deleteComment" id="deleteComment_'+data[i].id+'">Delete</a> | <a class="editComment" id="editComment_'+data[i].id+'">Edit</a></footer></article>');
		}
	}			
	
	$('.deletePost').live('click', function(e) {
		e.preventDefault();
		id = $(this).attr('id').replace('deletePost_', '');
		post.destroy(id, csrf, report);
		refresh();
	});
	
	$('#new_post').live('click', function(e) {
		e.preventDefault();
		post.create($('#post_username').val(), $('#post_text').val(), csrf, report);
		refresh();
	});
	
	$('.deleteComment').live('click', function(e) {
		e.preventDefault();
		id = $(this).attr('id').replace('deleteComment_', '');
		comment.destroy(id, csrf, report);
		refresh();
	});	
});
