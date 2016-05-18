import React, { Component, PropTypes } from 'react';
import { StyleSheet, View, Text, TextInput, TouchableHighlight, ListView } from 'react-native';

export default class TaskForm extends Component {
	render(){
		return (
			<View style={styles.container}>
				<TextInput style={styles.textInput} />

				<TouchableHighlight style={styles.button} >
					<Text style={styles.buttonTitle}>Add</Text>
				</TouchableHighlight>

				<TouchableHighlight style={[styles.button, styles.cancelButton]}>
					<Text style={styles.buttonTitle}>Cancel</Text>
				</TouchableHighlight>
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		paddingTop: 64,
		backgroundColor: '#e7e7e7'
	},
	textInput: {
		height: 50,
		borderWidth: 1,
		borderColor: '#ccc',
		marginLeft: 10,
		marginRight: 10,
	},
	button: {
		height: 40,
		backgroundColor: '#222',
		marginLeft: 10,
		marginRight: 10,
		marginTop: 10,
		alignItems: 'center',
		justifyContent: 'center',
	},
	buttonTitle: {
		color: '#e7e7e7',
		fontSize: 20,
		fontWeight: '300',
	},
	cancelButton: {
		backgroundColor: '#666',
	},
});