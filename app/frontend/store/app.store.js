export const SET_PER_PAGE = 'SET PER PAGE';
export const SET_SPINNER = 'SET SPINNER';
export const SET_LOCALE = 'SET LOCALE';


export const appStore = {
  state: {
    wholePageSpinner: false,
    perPage: 20,
    locale: null
  },
  mutations: {
    [SET_PER_PAGE](state, amt) {
      state.perPage = amt;
    },
    [SET_SPINNER](state, spinner) {
      state.wholePageSpinner = spinner;
    },
    [SET_LOCALE](state, locale) {
      state.locale = locale;
    }
  }
}
