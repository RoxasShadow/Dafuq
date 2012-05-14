function Post(per_page) {
	this.create = function(username, text, csrf, callback) {
		$.ajax({
			type: 'POST',
			url: '/post/new',
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
			url: '/post/edit',
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
			url: '/post/destroy',
			data: { id: id, _csrf: csrf },
			dataType: 'text',
			success: function(data) {
				callback(data);
			}
		});
	}

	this.count = function() {
		n = 0;
		$.ajax({
			type: 'GET',
			url: '/posts/count',
			dataType: 'text',
			success: function(data) {
				n = parseInt(data);
			}
		});
		return n;
	}
	
	this.get = function(id, page, callback) {
		$.ajax({
			type: 'GET',
			url: '/post'+ ((id == undefined) ? 's/page='+page+'/per_page='+per_page : '/id='+id),
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.getByUsername = function(username, page, callback) {
		$.ajax({
			type: 'GET',
			url: '/posts/username='+username+'/page='+page+'/per_page='+per_page,
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
	
	this.getBySearch = function(key, page, callback) {
		$.ajax({
			type: 'GET',
			url: '/post/search/key='+key+'/page='+page+'/per_page='+per_page,
			dataType: 'json',
			success: function(data) {
				callback(data);
			}
		});
	}
}
