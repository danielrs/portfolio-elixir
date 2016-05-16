export function renderErrorsFor(errors, ref) {
  if (!errors) return false;
  if (errors[ref]) {
    return errors[ref].map((error, i) => {
      return (
        <div key={i} className="error">
          {error}
        </div>
      );
    });
  }
}

export function zipIndex(objArr) {
  return objArr.map((x, index) => {
    x.index = index
    return x;
  });
}

export function dateToISO8601(date) {
  const year = date => ('0000' + date.getFullYear()).slice(-4);
  const month = date => ('00' + (date.getMonth() + 1)).slice(-2);
  const day = date => ('00' + date.getDate()).slice(-2);

  return year(date) + '-' + month(date) + '-' + day(date);
}
