package module2;

public class LibrarySearch {
    public static int linearSearch(Book[] books, String title) {
        for (int i = 0; i < books.length; i++) {
            if (books[i].getTitle().equalsIgnoreCase(title)) {
                return i;
            }
        }
        return -1;
    }

    public static int binarySearch(Book[] sortedBooks, String title) {
        int left = 0;
        int right = sortedBooks.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            int cmp = sortedBooks[mid].getTitle().compareToIgnoreCase(title);
            if (cmp == 0) {
                return mid;
            }
            if (cmp < 0) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1;
    }
}
