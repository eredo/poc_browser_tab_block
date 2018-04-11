import 'dart:html';

String tabId;

void workOn(int num) {
  String worker;
  if (window.localStorage.containsKey('w$num')) {
    worker = window.localStorage['w$num'];
  } else {
    worker = tabId;
  }

  if (worker != tabId) {
    window.alert('unable to start $num; worker $worker already working on it');
    return;
  }

  if (window.sessionStorage.containsKey('work')) {
    window.localStorage.remove('w${window.sessionStorage['work']}');
  }

  window.localStorage['w$num'] = tabId;
  window.sessionStorage['work'] = num.toString();

  current();
}

void current() =>
    document.querySelector('#c').innerHtml = window.sessionStorage['work'];

void handleChange(StorageEvent evt) =>
    document.querySelector('#h').append(document.createElement('div')
      ..innerHtml = 'Worker: ${evt.newValue} started working on ${evt.key}\n');

void main() {
  window.onStorage.where((c) => c.newValue != null && c.oldValue != c.newValue).listen(handleChange);

  if (!window.sessionStorage.containsKey('tabId')) {
    print('setting tabId');
    tabId = new DateTime.now().toUtc().toIso8601String();
    window.sessionStorage['tabId'] = tabId;
  } else {
    tabId = window.sessionStorage['tabId'];
    print('tabId: ${window.sessionStorage['tabId']}');
  }

  querySelector('#w1').onClick.listen((_) => workOn(1));
  querySelector('#w2').onClick.listen((_) => workOn(2));
  querySelector('#w3').onClick.listen((_) => workOn(3));

  current();
}
