# WebSearcher

It's a simple project, which can be used as a sample of my code. This project was developed as a test task at any one company.

**Task**

Write an application that searches text on a web-pages. The search begins with the initial url. All links on this page are used for further search - that is, you must perform a text search on the graph page. Use breadth-first search algorithm. Download pages - multi-threaded, the number of streams for simultaneous downloading - parameterized.

**Input data:**

1. Initial url
2. The maximum number of threads
3. Search text
4. The maximum number of scanning url

**Graphical user interface**

The application must contain a graphic interface that lets you:

1. Set the following parameters:
  - Initial url
  - The number of scan threads.
  - The search text
  - The maximum number of scanned url
2. Display the list of scanning / scanned URLs and the status of the scanning: - downloading / found / unfound / error (specify error)
3. Manage the download
  * "Start" button
  * "Stop"
  * The "Pause"
4. * Indicates the progress of completion using the progress bar.

Items marked with "*" are not required to perform.

**Optional**

1. Since the formulation of the problem may not have enough items, you will need to make judgments on their own. Be sure to include the assumptions that you have made so that we could check how much the task properly implemented in terms of its understanding of you.
2. Write how you propose to test the application.

(i) for easy reference implementation can be considered as a substring that starts with the substring HTTP: // and ends with one of the characters that can not be included in the URL
