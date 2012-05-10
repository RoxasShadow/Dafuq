function Post() {
	this.create = function(username, text, csrf, callback) {
		$.ajax({
			type: 'POST',
			url: '/post.new',
			data: { username: username, text: text, _csrf: csrf },
			dataType: 'text',
			success: function(data) {
				callback(data);
			}
		});
	}

	this.edit = function(id, text, csrf, callback) {
		$.ajax({
			type: 'POST',
			url: '/post.edit',
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
			url: '/post.destroy',
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
			url: '/post'+ ((id == undefined) ? 's' : '/'+id),
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.getByUsername = function(username, callback) {
		$.ajax({
			type: 'GET',
			url: '/posts/username='+username,
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.getBySearch = function(key, callback) {
		$.ajax({
			type: 'GET',
			url: '/post.search/'+key,
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
}
