import React, { Component, PropTypes } from 'react';
import { StyleSheet, View, Text, ListView } from 'react-native';

export default class TaskRow extends Component {
  static propTypes = {
    todo: PropTypes.shape({
      task: PropTypes.string.isRequired,
    }).isRequired,
  }
  render() {
    return (
      <View style={styles.container}>
        <Text>
          {this.props.todo.task}
        </Text>
      </View>

    );
  }
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: 'pink',
    borderWidth: 1,
    borderColor: '#e7e7e7',
    padding: 20,
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 20,
    marginLeft: 20,
    marginRight: 20,
  },

  label: {
    fontSize: 20,
    fontWeight: '300',
  },
});
