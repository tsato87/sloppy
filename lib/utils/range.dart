Iterable<int> range(int startOrStop, [int? stop, int step = 1]) sync* {
  int start = stop == null ? 0 : startOrStop;
  stop ??= startOrStop;

  if (step == 0) throw ArgumentError('step cannot be 0');
  if (step > 0 && stop < start) {
    throw ArgumentError('if step is positive, stop must be greater than start');
  }
  if (step < 0 && stop > start) {
    throw ArgumentError('if step is negative, stop must be less than start');
  }

  for (int value = start;
      step < 0 ? value > stop : value < stop;
      value += step) {
    yield value;
  }
}
