import moment from 'moment'
import numeral from 'numeral'
import 'numeral/locales'

export const locale = 'en'

moment.locale(locale)
numeral.locale(locale)

// test
// let number = 10000000.99;
// console.log('test!!!!!!');
// console.log(numeral(number).format('$ 0,0'));
