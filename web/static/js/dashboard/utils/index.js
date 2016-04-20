import React from 'react';

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
  // for (name of errors) {
    // console.log(name);
    // if (name == ref) {
    //   return errors[ref].map((error, i) => {
    //     return (
    //       <div key={i} className="error">
    //         {error}
    //       </div>
    //     );
    //   });
    // }
  // }
}

// export function renderErrorsFor(errors, ref) {
//   if (!errors) return false;
//   return errors.map((error, i) => {
//     if (error[ref]) {
//       return (
//         <div key={i} className="error">
//           {error[ref]}
//         </div>
//       );
//     }
//   });
// }
