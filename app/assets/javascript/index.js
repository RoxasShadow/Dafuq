$(document).ready(function() {

	per_page = 4;
	post = new Post(per_page);
	comment = new Comment();
	csrf = $('[name="_csrf"]').val();
	pagePost = 1;
	pageSearch = 1;
	nPagePost = Math.ceil(post.count() / per_page);
	lang = (navigator.language.substr(0, 2) == 'it') ? Languages.it : Languages.en;
	
	refresh();
	setInterval(function() { refresh(); }, 5000);

	function auth() {
		if($('#post_username').val() == '' && $.cookie('username') != null)
			$('#post_username').val($.cookie('username'));
		if($('#username').val() == '' && $.cookie('username') != null)
			$('#username').val($.cookie('username'));
	}
	
	function refresh(reset) {
		if(reset === undefined)
			$('#posts').html('');
		post.get(undefined, pagePost, postsHandler);
		comment.get(undefined, commentsHandler);
		auth();
	}
	
	function report(text) {
		text = translate(text);
		$('#notice').fadeIn('slow');
		if(isArray(text))
			$('#notice').attr('class', (text[0] == Status.OK) ? 'good' : 'bad').html(text[lang]);
		else
			$('#notice').attr('class', (text == Status.OK) ? 'good' : 'bad').html(text);
		setTimeout("$('#notice').fadeOut('slow');", 5000);
	}
	
	function postsHandler(data) {
		if(data == undefined)
			return;
		for(i=0, len=data.length; i<len; ++i) {
			if(data[i] == undefined || data[i].username == undefined)
				continue;
			date = $.format.date(data[i].created_at, 'MM/dd/yyyy') + ' at ' + $.format.date(data[i].created_at, 'HH:mm:ss');
			$('#posts').append('<article id="post_'+data[i].id+'" class="post"><header>Written by '+data[i].username+' the <time pubdate datetime="'+data[i].created_at+'">'+date+'</time> (+'+data[i].up+')</header><p>'+data[i].text+'</p><footer><a class="replyPost" id="replyPost_'+data[i].id+'">Reply</a> | <a class="deletePost" id="deletePost_'+data[i].id+'">Delete</a> | <a class="upPost" id="upPost_'+data[i].id+'">Up</a> | <a class="editPost" id="editPost_'+data[i].id+'">Edit</a></footer></article><hr /\>');
		}
		if(nPagePost > pagePost) {
			$('#morePosts').remove();
			$('#posts').append('<a id="morePosts">More</a>');
		}
	}
	
	function searchHandler(data) {
		if(data == undefined)
			return;
		for(i=0, len=data.length; i<len; ++i) {
			if(data[i] == undefined || data[i].username == undefined)
				continue;
			date = $.format.date(data[i].created_at, 'MM/dd/yyyy') + ' at ' + $.format.date(data[i].created_at, 'HH:mm:ss');
			$('#posts').append('<article id="post_'+data[i].id+'" class="post"><header>Written by '+data[i].username+' the <time pubdate datetime="'+data[i].created_at+'">'+date+'</time> (+'+data[i].up+')</header><p>'+data[i].text+'</p><footer><a class="replyPost" id="replyPost_'+data[i].id+'">Reply</a> | <a class="deletePost" id="deletePost_'+data[i].id+'">Delete</a> | <a class="upPost" id="upPost_'+data[i].id+'">Up</a> | <a class="editPost" id="editPost_'+data[i].id+'">Edit</a></footer></article><hr /\>');
		}
		if(nPagePost > pagePost) {
			$('#moreSearch').remove();
			$('#posts').append('<a id="moreSearch">More</a>');
		}
		$('#posts').append('<a id="index">Index</a>');
	}
	
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
	
	function search() {
		$('#posts').html('');
		post.getBySearch($('#search').val(), pageSearch, searchHandler);
	}
	
	$('#new_search').live('click', function(e) {
		e.preventDefault();
		pagePost = 1;
		search();
	});
	
	$('#moreSearch').live('click', function(e) {
		e.preventDefault();
		++pageSearch;
		search();
	});
	
	$('#index').live('click', function(e) {
		e.preventDefault();
		pageSearch = 1;
		pagePost = 1;
		refresh();
	});
		
});
