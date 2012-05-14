Status = {
	'OK' 				: 1,
	'ERROR'			: 2,
	'DENIED'		: 3,
	'NOT_FOUND'	: 4
};

Languages = {
	'en'				:	1,
	'it'				: 2
}

function translate(data) {
	if(data == Status.OK)
		data = [data, 'Done.', 'Fatto.'];
	else if(data == Status.ERROR)
		data = [data, 'Error.', 'Errore.'];
	else if(data == Status.DENIED)
		data = [data, 'Denied.', 'Negato.'];
	else if(data == Status.NOT_FOUND)
		data = [data, 'Not found.', 'Non trovato.'];
	return data;
}
