// counter.js

import * as types from './actionTypes';

function increase() {
	return {
		type: types.INCREASE,
	};
}

function decrease() {
	return {
		type: types.DECREASE,
	};
}


