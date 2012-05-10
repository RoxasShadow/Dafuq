function Comment() {
	this.create = function(post_id, username, text, engine) {
		$.ajax({
			type: 'POST',
			url: '/comment.new',
			data: { post_id: post_id, username: username, text: text },
			dataType: 'text',
			success: function(data) {
				callback(data);
			}
		});
	}

	this.edit = function(id, text, engine) {
		$.ajax({
			type: 'POST',
			url: '/comment.edit',
			data: { id: id, text: text },
			dataType: 'text',
			success: function(data) {
				callback(data);
			}
		});
	}

	this.destroy = function(id, engine) {
		$.ajax({
			type: 'POST',
			url: '/comment.destroy',
			data: { id: id },
			dataType: 'text',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.get = function(id, engine) {
		$.ajax({
			type: 'GET',
			url: '/comment'+ ((id == undefined) ? 's' : '/'+id),
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.getByPost = function(post_id, engine) {
		$.ajax({
			type: 'GET',
			url: '/comments/post_id='+post_id,
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.getByUsername = function(username, engine) {
		$.ajax({
			type: 'GET',
			url: '/comments/username='+username,
			dataType: 'json',
			success: function(data) {
				return data;
			}
		});
	}
	
	this.getBySearch = function(key, engine) {
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
