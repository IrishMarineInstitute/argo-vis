/**
 * Copyright 2017 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

const puppeteer = require('puppeteer');

(async() => {
  const browser = await puppeteer.launch({
	          args: [
            '--no-sandbox',
            '--disable-setuid-sandbox'
        ]
  });
  const page = await browser.newPage();

  var snapno = 0;
  var lastsnap = 3;
  // Define a window.onCustomEvent function on the page.
  await page.exposeFunction('snapshot', document => {
    var name = "00000000000000000"+snapno++;
	  name = name.substr(name.length - 6);
	  var path = '/output/snap-'+name+'.png';
	  if(snapno <= lastsnap){
	         console.log(path);
                 page.screenshot({path: path});
	  }

	 // if(snapno == lastsnap) document.dispatchEvent(new Event("tada"));
	 if(snapno == lastsnap) page.evaluate(()=>document.dispatchEvent(new Event("tada")));
  });

  /**
   * Attach an event listener to page to capture a custom event on page load/navigation.
   * @param {string} type Event name.
   * @return {!Promise}
   */
  function listenFor(type) {
    return page.evaluateOnNewDocument(type => {
      document.addEventListener(type, e => {
        //owindow.takeSnapshot({type, detail: e.detail});
	console.log("got tada");
      });
    }, type);
  }


  await page.goto('https://spiddal.marine.ie/argos/', {waitUntil: 'networkidle0'});

  await listenFor('tada'); // Listen for "app-ready" custom event on page load.
  await browser.close();

})();
