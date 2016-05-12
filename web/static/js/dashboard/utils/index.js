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
