// counter.js

import React, { Component } from 'react';
import { View, StyleSheet, TouchableOpacity, Text, TextInput } from 'react-native';

export default Counter extends Component {
	render() {
		return (
			<View style={styles.container}>
				<TouchableOpacity style={styles.button}>
					<Text>-</Text>
				</TouchableOpacity>

				<Text>0</Text>

				<TouchableOpacity style={styles.button}>
					<Text>+</Text>
				</TouchableOpacity>

			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		alignItems: 'center',
		backgroundColor: '#ccc',
		justifyContent: 'center',
	},

	button: {
		width: 40,
		height: 40,
		alignItems: 'center',
		justifyContent: 'center',
	},

});