namespace DirectoryStructureViewer
{
    [Serializable]
    public class CustomStringComparer : IComparer<string>
    {
        public int Compare(string? x, string? y)
        {
            if (x == null || y == null)
                return 0;
            if (x.Length > y.Length)
                return 1;
            if (x.Length < y.Length)
                return -1;
            if (x.Length == y.Length)
                for (int i = 0; i < x.Length; i++)
                {
                    int comparison = x[i].CompareTo(y[i]);
                    if (comparison != 0)
                    {
                        return comparison;
                    }
                }
            return 0;
        }
    }
}

