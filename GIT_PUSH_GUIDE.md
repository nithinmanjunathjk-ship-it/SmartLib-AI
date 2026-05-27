# GitHub Push Guide - SmartLib AI

## 🚀 Quick Push Commands (Without Reaching Limits)

### Initial Setup

```bash
# Navigate to project directory
cd smartlib_ai

# Initialize git (if not already done)
git init

# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/smartlib_ai.git
```

### Strategy 1: Push in Chunks (Recommended)

This approach splits commits to avoid size limits:

```bash
# Stage and commit core files
git add pubspec.yaml README.md LICENSE .gitignore
git commit -m "Add core project files"
git push -u origin main

# Stage and commit source code in chunks
git add lib/core/
git commit -m "Add core utilities and theme"
git push origin main

git add lib/data/
git commit -m "Add data models and repositories"
git push origin main

git add lib/presentation/
git commit -m "Add presentation layer and screens"
git push origin main

# Stage and commit Android files
git add android/
git commit -m "Add Android configuration"
git push origin main

# Stage and commit remaining files
git add .github/ assets/ supabase_schema.sql
git commit -m "Add CI/CD, assets and database schema"
git push origin main
```

### Strategy 2: Single Commit (For Small Projects)

```bash
# Add all files
git add .

# Commit with message
git commit -m "Initial commit: SmartLib AI - Complete project setup"

# Push to GitHub
git push -u origin main
```

### Strategy 3: Use Git LFS for Large Files

If you have large assets:

```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.png"
git lfs track "*.jpg"
git lfs track "*.pdf"

# Add gitattributes
git add .gitattributes

# Continue normal workflow
git add .
git commit -m "Initial commit with LFS"
git push -u origin main
```

## 🔧 Troubleshooting

### Error: File size exceeds limit

```bash
# Remove large files from git
git rm --cached path/to/large/file

# Add to .gitignore
echo "path/to/large/file" >> .gitignore

# Commit changes
git add .gitignore
git commit -m "Remove large files"
git push origin main
```

### Error: Push rejected

```bash
# Pull first, then push
git pull origin main --rebase
git push origin main
```

### Error: Authentication failed

```bash
# Use personal access token instead of password
# Generate token at: https://github.com/settings/tokens

# When prompted, use token as password
```

## 📊 Check Repository Size

```bash
# Check size before pushing
git count-objects -vH

# If size > 100MB, consider chunking
```

## 🎯 Best Practices

1. **Commit frequently** - Smaller commits are better
2. **Use .gitignore** - Exclude build files and dependencies
3. **Meaningful messages** - Describe what changed
4. **Test locally** - Ensure code works before pushing
5. **Branch strategy** - Use branches for features

## 📝 Commit Message Format

```bash
# Format
git commit -m "Type: Brief description"

# Types
feat: New feature
fix: Bug fix
docs: Documentation
style: Formatting
refactor: Code restructuring
test: Adding tests
chore: Maintenance
```

## 🌿 Branch Workflow

```bash
# Create feature branch
git checkout -b feature/book-scanning

# Make changes and commit
git add .
git commit -m "feat: Add QR code scanning"

# Push feature branch
git push origin feature/book-scanning

# Merge to main (via PR on GitHub)
```

## ⚡ Quick Commands Reference

```bash
# Check status
git status

# View commits
git log --oneline

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Discard local changes
git checkout -- .

# Update from remote
git pull origin main

# View remote
git remote -v
```

## 🔐 Security Notes

- Never commit API keys or secrets
- Use environment variables
- Add sensitive files to .gitignore
- Review changes before pushing

## 📦 Final Checklist

- [ ] All sensitive data removed
- [ ] .gitignore configured
- [ ] README.md updated
- [ ] Tests passing
- [ ] Code formatted
- [ ] Commits are logical
- [ ] Remote repository created
- [ ] Ready to push!

---

**Happy Coding! 🚀**
