# BunkerOS Development Packages

## Philosophy: Universal Essentials

BunkerOS includes development tools and programming languages that **most Linux developers will eventually need**, avoiding favoritism while ensuring productivity from day one.

## Programming Languages (Pre-installed)

### Core Languages
- **Python + pip** - Data science, automation, scripting, AI/ML
- **JavaScript (Node.js + npm)** - Web development, tooling, build systems  
- **Rust + cargo** - Systems programming, modern CLI tools
- **Go** - Cloud native development, microservices, containers
- **Java (OpenJDK)** - Enterprise development, Android, cross-platform

### Why These Five?
1. **Python**: Essential for data science, automation, and system administration
2. **JavaScript**: Ubiquitous in web development and modern tooling
3. **Rust**: Growing rapidly, used by modern Linux tools (ripgrep, fd, etc.)
4. **Go**: Standard for cloud infrastructure and containerization
5. **Java**: Still massive in enterprise and cross-platform development

## Container Technology

### Docker (Default)
- **Docker + Docker Compose** - Industry standard container platform
- **Service enabled by default** - Ready to use immediately
- **User added to docker group** - No sudo required after reboot

### Why Docker over Podman?
- More familiar to developers
- Better ecosystem and documentation
- Industry standard for development workflows
- Extensive Docker Compose support

## Development Tools

### System Monitoring
- **btop only** (not htop) - Modern, feature-rich process monitor
- Avoids redundancy and user confusion
- Better visualization and theming support

### Version Control & Build
- **git** (base system)
- **git-lfs** - Large file support
- **base-devel** - Complete build toolchain (gcc, make, etc.)

### Debugging & Profiling
- **gdb** - GNU debugger
- **strace/ltrace** - System/library call tracing  
- **valgrind** - Memory debugging and profiling

### Modern CLI Tools
- **ripgrep (rg)** - Fast grep replacement
- **fd** - Fast find replacement
- **bat** - Syntax-highlighted cat
- **tree** - Directory visualization

### Network & Utilities
- **curl/wget** - HTTP clients
- **zip/unzip/tar** - Archive utilities
- **sqlite** - Embedded database for development

## Excluded Languages (By Design)

### Tier 2 Languages (Optional Install)
- **C#/.NET** - Growing on Linux but still niche
- **PHP** - Web-specific, declining usage
- **Ruby** - Rails-specific, niche use cases
- **Lua** - Very specialized use cases

### Rationale
Rather than including everything and creating bloat, BunkerOS provides the **universal essentials** that apply to most developers. Specialized languages can be installed via package manager when needed.

## Installation Size Impact

### Added Packages (~500MB total)
- Python ecosystem: ~100MB
- Node.js ecosystem: ~150MB  
- Rust toolchain: ~200MB
- Go compiler: ~100MB
- Java OpenJDK: ~150MB
- Docker: ~100MB
- Development tools: ~50MB

### Comparison with Major Distros
| Distribution | Default Dev Tools | BunkerOS Advantage |
|--------------|-------------------|-------------------|
| **Ubuntu Desktop** | Minimal (Python only) | +4 languages, modern tools |
| **Fedora Workstation** | Good coverage | Similar scope, lighter weight |
| **Pop!_OS** | Good for gaming/dev | More complete, cleaner selection |

## Usage Examples

### Container Development
```bash
# Ready immediately after installation
docker run hello-world
docker-compose up -d
```

### Multi-language Project
```bash
# All tools available out-of-box
python -m venv venv        # Python virtual env
npm init -y               # Node.js project
cargo new rust-project    # Rust project  
go mod init myproject     # Go module
javac HelloWorld.java     # Java compilation
```

### Modern Workflow
```bash
# Enhanced CLI tools included
rg "TODO" --type rust     # Fast code search
fd "*.py" | head -10      # Fast file finding
bat config.json           # Syntax highlighted viewing
tree src/                 # Directory visualization
```

## Future Considerations

### Optional Language Packs (Future)
Could add optional language pack installers:
- **Web Dev Pack**: PHP, additional Node.js tools
- **Systems Pack**: C/C++ enhancements, assembly tools  
- **Data Science Pack**: R, Julia, additional Python libraries
- **Mobile Pack**: Kotlin, Flutter/Dart

### DevOps Extensions (AUR/Optional)
- **Terraform** - Infrastructure as code
- **Ansible** - Configuration management
- **Kubernetes tools** - kubectl, helm, minikube

---

**Result**: BunkerOS now provides a **developer-first experience** that rivals or exceeds major Linux distributions while maintaining its lightweight, tactical desktop philosophy.