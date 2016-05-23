// counter.js

import * as types from './actionTypes';

export function increase() {
	return {
		type: types.INCREASE,
	};
}

export function decrease() {
	return {
		type: types.DECREASE,
	};
}
