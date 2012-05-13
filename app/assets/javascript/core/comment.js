function Comment() {
	this.create = function(post_id, username, text, csrf, callback) {
		$.ajax({
			type: 'POST',
			url: '/comment.new',
			data: { post_id: post_id, username: username, text: text, _csrf: csrf },
			dataType: 'text',
			success: function(data) {
				callback(data);
			}
		});
	}

	this.edit = function(id, text, csrf, callback) {
		$.ajax({
			type: 'POST',
			url: '/comment.edit',
			data: { id: id, text: text, _csrf: csrf },
			dataType: 'text',
			success: function(data) {
				callback(data);
			}
		});
	}

	this.destroy = function(id, csrf, callback) {
		$.ajax({
			type: 'POST',
			url: '/comment.destroy',
			data: { id: id, _csrf: csrf },
			dataType: 'text',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.get = function(id, callback) {
		$.ajax({
			type: 'GET',
			url: '/comment'+ ((id == undefined) ? 's' : '/'+id),
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.getByPost = function(post_id, callback) {
		$.ajax({
			type: 'GET',
			url: '/comments/post_id='+post_id,
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.getByUsername = function(username, callback) {
		$.ajax({
			type: 'GET',
			url: '/comments/username='+username,
			dataType: 'json',
			success: function(data) {
				return data;
			}
		});
	}
	
	this.getBySearch = function(key, callback) {
		$.ajax({
			type: 'GET',
			url: '/comment.search/'+key,
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
}