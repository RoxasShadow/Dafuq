$(document).ready(function() {

	per_page = 5;
	post = new Post(per_page);
	comment = new Comment();
	csrf = $('[name="_csrf"]').val();
	pagePost = 1;
	nPagePost = Math.ceil(post.count() / per_page);
	searchActive = false;
	
	auth();
	refresh();
	
	setInterval(function() {
		if(!searchActive)
			refresh();
	}, 50000);

	function auth() {
		if($('#post_username').val() == '' && $.cookie('username') != null)
			$('#post_username').val($.cookie('username'));
		if($('#sendcomment_dialog_username').val() == '' && $.cookie('username') != null)
			$('#sendcomment_dialog_username').val($.cookie('username'));
	}
	
	function refresh(reset) {
		if(reset === undefined)
			$('#posts').html('');
		post.get(undefined, pagePost, postsHandler);
		comment.get(undefined, commentsHandler);
	}

	function translate(data) {
		if(data == Status.OK)
			return ['Done.', Status.OK, 'good'];
		else if(data == Status.ERROR)
			return ['Error.', Status.OK, 'bad'];
		else if(data == Status.DENIED)
			return ['Denied.', Status.OK, 'bad'];
		else if(data == Status.NOT_FOUND)
			return ['Not found.', Status.OK, 'bad'];
		return data;
	}
	
	function report(text) {
		text = translate(text);
		$('#notice').fadeIn('slow');
		if(isArray(text)) {
			notice = text.length == 3;
			$('#notice').attr('class', (notice ? text[2] : 'bad')).html((notice ? text[0] : text));
		}
		else
			$('#notice').attr('class', 'bad').html(text);
		setTimeout("$('#notice').fadeOut('slow');", 1000);
	}
	
	function postsHandler(data) {
		if(data == undefined)
			return;
		len = data.length;
		for(i=0; i<len; ++i) {
			if(data[i] == undefined || data[i].username == undefined)
				continue;
			edited = data[i].created_at != data[i].updated_at;
			$('#posts').append('<article id="post_'+data[i].id+'" class="post"><header>Written by <a href="/user/'+data[i].username+'">'+data[i].username+'</a> <time pubdate datetime="'+data[i].created_at+'">'+data[i].created_at_in_words+'</time> (+'+data[i].up+')</header><p>'+data[i].text+'</p><footer><a class="replyPost" id="replyPost_'+data[i].id+'">Reply</a> | <a class="deletePost" id="deletePost_'+data[i].id+'">Delete</a> | <a class="upPost" id="upPost_'+data[i].id+'">Up</a> | <a class="editPost" id="editPost_'+data[i].id+'">Edit</a>'+(edited ? ' | Last edit <time pubdate datetime="'+data[i].updated_at+'">'+data[i].updated_at_in_words+'</time>' : '')+'</footer></article><hr /\>');
		}
		if(!searchActive) {
			if(nPagePost > pagePost) {
				$('#morePosts').remove();
				$('#posts').append('<a id="morePosts">More</a>');
			}
		}
		else
			$('#posts').append('<a id="index">Index</a>');
	}
	
	function commentsHandler(data) {
		if(data == undefined)
			return;
		for(i=0, len=data.length; i<len; ++i) {
			if(data[i] == undefined || data[i].username == undefined)
				continue;
			edited = data[i].created_at != data[i].updated_at;
			$('#post_'+data[i].post_id).append('<article id="comment_'+data[i].id+'" class="comment"><header>Written by <a href="/user/'+data[i].username+'">'+data[i].username+'</a> <time pubdate datetime="'+data[i].created_at+'">'+data[i].created_at_in_words+'</time></header><p>'+data[i].text+'</p><footer><a class="deleteComment" id="deleteComment_'+data[i].id+'">Delete</a> | <a class="editComment" id="editComment_'+data[i].id+'">Edit</a>'+(edited ? ' | Last edit <time pubdate datetime="'+data[i].updated_at+'">'+data[i].updated_at_in_words+'</time>' : '')+'</footer></article>');
		}
	}
	
	$('#dialog:ui-dialog').dialog('destroy');
	
	$('#sendcomment_dialog').dialog({
		autoOpen: false,
		width: 350,
		modal: true,
		buttons: {
			"Send comment": function() {
				item = $(this);
				id = $('#sendcomment_dialog_post_id').val();
				username = item.parent().find('#sendcomment_dialog_username').val();
				text = item.parent().find('#sendcomment_dialog_text').val();
				comment.create(id, username, text, csrf, report);
				refresh();
				item.dialog('close');
			},
			Cancel: function() {
				$(this).dialog('close');
			}
		},
		close: function() {
			$('#sendcomment_dialog_username').val('');
			$('#sendcomment_dialog_text').val('');
		}
	});
	
	$('#editpost_dialog').dialog({
		autoOpen: false,
		width: 350,
		modal: true,
		buttons: {
			"Edit post": function() {
				item = $(this);
				id = $('#editpost_dialog_post_id').val();
				text = item.parent().find('#editpost_dialog_text').val();
				post.edit(id, text, csrf, report);
				refresh();
				item.dialog('close');
			},
			Cancel: function() {
				$(this).dialog('close');
			}
		},
		close: function() {
			$('#editpost_dialog_text').val('');
		}
	});
	
	$('#editcomment_dialog').dialog({
		autoOpen: false,
		width: 350,
		modal: true,
		buttons: {
			"Edit comment": function() {
				item = $(this);
				id = $('#editcomment_dialog_post_id').val();
				text = item.parent().find('#editcomment_dialog_text').val();
				comment.edit(id, text, csrf, report);
				refresh();
				item.dialog('close');
			},
			Cancel: function() {
				$(this).dialog('close');
			}
		},
		close: function() {
			$('#editcomment_dialog_text').val('');
		}
	});
	
	$('.editComment').live('click', function() {
		item = $(this)
		id = item.attr('id').replace('editComment_', '');
		text = item.parent().parent().find('p').html();
		$('#editcomment_dialog_post_id').val(id);
		$('#editcomment_dialog_text').val(text);
		$('#editcomment_dialog').attr('title', 'Edit').dialog('open');
	});
	
	$('.editPost').live('click', function() {
		item = $(this)
		id = item.attr('id').replace('editPost_', '');
		text = item.parent().parent().find('p').html();
		$('#editpost_dialog_post_id').val(id);
		$('#editpost_dialog_text').val(text);
		$('#editpost_dialog').attr('title', 'Edit').dialog('open');
	});
	
	$('.replyPost').live('click', function() {
		auth();
		id = $(this).attr('id').replace('replyPost_', '');
		$('#sendcomment_dialog_post_id').val(id);
		$('#sendcomment_dialog').attr('title', 'Reply').dialog('open');
	});
	
	$('.deletePost').live('click', function(e) {
		e.preventDefault();
		id = $(this).attr('id').replace('deletePost_', '');
		post.destroy(id, csrf, report);
		refresh();
	});
	
	$('#morePosts').live('click', function(e) {
		e.preventDefault();
		++pagePost;
		refresh(false);
	});
	
	$('#new_post').live('click', function(e) {
		auth();
		e.preventDefault();
		post.create($('#post_username').val(), $('#post_text').val(), csrf, report);
		refresh();
	});
	
	$('.upPost').live('click', function(e) {
		e.preventDefault();
		id = $(this).attr('id').replace('upPost_', '');
		post.up(id, csrf, report);
		refresh();
	});
	
	$('.deleteComment').live('click', function(e) {
		e.preventDefault();
		id = $(this).attr('id').replace('deleteComment_', '');
		comment.destroy(id, csrf, report);
		refresh();
	});
	
	function searchPost() {
		$('#posts').html('');
		post.getBySearch($('#search').val(), undefined, postsHandler);
	}
	
	$('#new_search').live('click', function(e) {
		e.preventDefault();
		pagePost = 1;
		searchActive = true;
		searchPost();
	});
	
	$('#index').live('click', function(e) {
		e.preventDefault();
		pagePost = 1;
		searchActive = false;
		refresh();
	});
	
});
