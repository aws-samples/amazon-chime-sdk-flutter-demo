class UninitializedException implements Exception {
  final String messsage;
  const UninitializedException({
    this.messsage = 'Data source is not implemented yet',
  });
}
