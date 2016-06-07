import React from 'react';

// Misc
export function Enum(values) {
  for (let value of values) {
    this[value] = value;
  }
}

// Views
export function renderErrorsFor(errors, ref) {
  if (!errors) return false;
  if (errors[ref]) {
    return errors[ref].map((error, i) => {
      return (
        <div key={i} className="form-validation is-invalid">
          {error}
        </div>
      );
    });
  }
}

export function dateToISO8601(date) {
  const year = date => ('0000' + date.getFullYear()).slice(-4);
  const month = date => ('00' + (date.getMonth() + 1)).slice(-2);
  const day = date => ('00' + date.getDate()).slice(-2);

  return year(date) + '-' + month(date) + '-' + day(date);
}
