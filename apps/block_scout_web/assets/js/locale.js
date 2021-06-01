import moment from 'moment'
import numeral from 'numeral'
import 'numeral/locales'

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}

let locale = getCookie('locale')
if (!locale) document.cookie = `locale=en`;

moment.locale(locale)
numeral.locale('en')

function setLocale(locale) {
  locale = locale;
  document.cookie.locale = locale
  moment.locale(locale)
}

export { locale, setLocale };


// test
// let number = 10000000.99;
// console.log('test!!!!!!');
// console.log(numeral(number).format('$ 0,0'));
