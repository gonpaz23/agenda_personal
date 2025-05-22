import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Personal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Personal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.check_circle), text: 'Tareas'),
            Tab(icon: Icon(Icons.note), text: 'Notas'),
            Tab(icon: Icon(Icons.contacts), text: 'Contactos'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función de búsqueda activada')),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menú de Navegación', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Tareas'),
              onTap: () {
                _tabController.animateTo(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Notas'),
              onTap: () {
                _tabController.animateTo(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Contactos'),
              onTap: () {
                _tabController.animateTo(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TasksTab(),
          NotesTab(),
          ContactsTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    switch (_currentTabIndex) {
      case 0: // Tareas
        return FloatingActionButton(
          onPressed: _addNewTask,
          child: const Icon(Icons.add_task),
          tooltip: 'Añadir nueva tarea',
        );
      case 1: // Notas
        return FloatingActionButton(
          onPressed: _addNewNote,
          child: const Icon(Icons.note_add),
          tooltip: 'Crear nueva nota',
        );
      case 2: // Contactos
        return FloatingActionButton(
          onPressed: _addNewContact,
          child: const Icon(Icons.contact_page),
          tooltip: 'Agregar nuevo contacto',
        );
      default:
        return FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.error),
        );
    }
  }

  void _addNewTask() {
    // Lógica para añadir nueva tarea
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nueva tarea añadida')),
    );
  }

  void _addNewNote() {
    // Lógica para añadir nueva nota
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nueva nota creada')),
    );
  }

  void _addNewContact() {
    // Lógica para añadir nuevo contacto
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nuevo contacto agregado')),
    );
  }
}

// Widget Personalizado Mejorado
class CustomItem extends StatelessWidget {
  final String title;
  final String? description;
  final String? subtitle;
  final IconData? icon;
  final bool? isCompleted;
  final bool? isExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final ItemType type;

  const CustomItem({
    super.key,
    required this.title,
    this.description,
    this.subtitle,
    this.icon,
    this.isCompleted,
    this.isExpanded,
    this.onTap,
    this.onDoubleTap,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _getBorderColor(),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) 
              Icon(icon, color: _getIconColor(), size: 28),
            if (icon != null) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted == true ? TextDecoration.lineThrough : null,
                      color: _getTitleColor(),
                    ),
                  ),
                  if (description != null && (type == ItemType.task || (type == ItemType.note && isExpanded == true))) 
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: _getDescriptionColor(),
                        ),
                      ),
                    ),
                  if (subtitle != null && type == ItemType.contact)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isCompleted != null)
              Icon(
                isCompleted! ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted! ? Colors.green : Colors.grey,
                size: 28,
              ),
            if (type == ItemType.note)
              Icon(
                isExpanded == true ? Icons.expand_less : Icons.expand_more,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ItemType.task:
        return isCompleted == true ? Colors.green[50]! : Colors.white;
      case ItemType.note:
        return isExpanded == true ? Colors.blue[50]! : Colors.white;
      case ItemType.contact:
        return Colors.white;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case ItemType.task:
        return isCompleted == true ? Colors.green : Colors.grey[300]!;
      case ItemType.note:
        return Colors.blue[200]!;
      case ItemType.contact:
        return Colors.grey[300]!;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case ItemType.task:
        return isCompleted == true ? Colors.green : Colors.blue;
      case ItemType.note:
        return Colors.blue;
      case ItemType.contact:
        return Colors.blue;
    }
  }

  Color _getTitleColor() {
    switch (type) {
      case ItemType.task:
        return isCompleted == true ? Colors.grey : Colors.black;
      case ItemType.note:
        return Colors.black;
      case ItemType.contact:
        return Colors.black;
    }
  }

  Color _getDescriptionColor() {
    switch (type) {
      case ItemType.task:
        return isCompleted == true ? Colors.grey : Colors.grey[700]!;
      case ItemType.note:
        return Colors.grey[700]!;
      case ItemType.contact:
        return Colors.grey[700]!;
    }
  }
}

enum ItemType {
  task,
  note,
  contact,
}

// Pestaña de Tareas
class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Apagar la luz',
      'description': 'Asegurarse de apagar todas las luces antes de salir',
      'completed': false
    },
    {
      'title': 'Apagar la estufa',
      'description': 'Verificar que todos los quemadores estén apagados',
      'completed': false
    },
    {
      'title': 'Apagar el televisor',
      'description': 'No dejar el televisor en modo standby',
      'completed': false
    },
  ];

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['completed'] = !tasks[index]['completed'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tasks[index]['completed'] 
            ? '✅ Tarea completada: ${tasks[index]['title']}' 
            : '🔄 Tarea pendiente: ${tasks[index]['title']}'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            setState(() {
              tasks[index]['completed'] = !tasks[index]['completed'];
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return CustomItem(
          title: tasks[index]['title'],
          description: tasks[index]['description'],
          isCompleted: tasks[index]['completed'],
          icon: Icons.task,
          onTap: () => toggleTaskCompletion(index),
          type: ItemType.task,
        );
      },
    );
  }
}

// Pestaña de Notas
class NotesTab extends StatefulWidget {
  const NotesTab({super.key});

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  final List<Map<String, dynamic>> notes = [
    {
      'title': 'Ideas para el proyecto',
      'content': 'Investigar sobre providers y bloc pattern',
      'expanded': false
    },
    {
      'title': 'Recordatorios',
      'content': 'Llamar al médico\nPagar la factura de luz\nEnviar correo al profesor',
      'expanded': false
    },
  ];

  void toggleNoteExpansion(int index) {
    setState(() {
      notes[index]['expanded'] = !notes[index]['expanded'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(notes[index]['expanded'] 
            ? 'Nota expandida' 
            : 'Nota contraída'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return CustomItem(
          title: notes[index]['title'],
          description: notes[index]['content'],
          isExpanded: notes[index]['expanded'],
          icon: Icons.note,
          onDoubleTap: () => toggleNoteExpansion(index),
          type: ItemType.note,
        );
      },
    );
  }
}

// Pestaña de Contactos
class ContactsTab extends StatefulWidget {
  const ContactsTab({super.key});

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  final List<Map<String, String>> contacts = [
    {'name': 'Juan Pérez', 'phone': '555-1234'},
    {'name': 'María García', 'phone': '555-5678'},
  ];

  void saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambios en contactos guardados')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return CustomItem(
                title: contacts[index]['name']!,
                subtitle: 'Tel: ${contacts[index]['phone']}',
                icon: Icons.person,
                type: ItemType.contact,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: saveChanges,
            child: const Text('Guardar Cambios'),
          ),
        ),
      ],
    );
  }
}