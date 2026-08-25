#Exercício 1

app.get('/produtos/busca/:nome', async (req, res) => {
  try {
    const { nome } = req.params;
    const [produtos] = await db.query('SELECT * FROM produtos WHERE nome LIKE ? ORDER BY id', [`%${nome}%`]);
 
    if (produtos.length === 0) {
      return res.status(404).json({ message: 'Nenhum produto encontrado com o nome especificado.' });
    }
 
    res.json(produtos);
  } catch (error) {
    console.error('Erro ao buscar produtos por nome:', error);
    res.status(500).json({ message: 'Erro ao buscar produtos por nome.' });
  }
});


#Exercício 2

app.post('/produtos', async (req, res) => {
  try {
    const { nome, preco, descricao } = req.body;
 
    if (!nome || !preco) {
      return res.status(400).json({ message: 'Nome e preço são obrigatórios.' });
    }
 
    if (preco <= 0) {
      return res.status(400).json({ message: 'O preço deve ser um valor positivo.' });
    }
 
    const [resultado] = await db.query(
      'INSERT INTO produtos (nome, preco, descricao) VALUES (?, ?, ?)',
      [nome, preco, descricao || null]
    );
 
    res.status(201).json({
      id: resultado.insertId,
      nome,
      preco,
      descricao: descricao || null,
    });
  } catch (error) {
    console.error('Erro ao criar produto:', error);
    res.status(500).json({ message: 'Erro ao criar produto.' });
  }
});
 
#Exercício 3

CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

#Exercício 4

app.get('/categorias', async (req, res) => {
  try {
    const [categorias] = await db.query('SELECT * FROM categorias ORDER BY id');
    res.json(categorias);
  } catch (error) {
    console.error('Erro ao listar categorias:', error);
    res.status(500).json({ message: 'Erro ao listar categorias.' });
  }
});
 
// Buscar categoria por ID
app.get('/categorias/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const [categorias] = await db.query('SELECT * FROM categorias WHERE id = ?', [id]);
 
    if (categorias.length === 0) {
      return res.status(404).json({ message: 'Categoria não encontrada.' });
    }
 
    res.json(categorias[0]);
  } catch (error) {
    console.error('Erro ao buscar categoria:', error);
    res.status(500).json({ message: 'Erro ao buscar categoria.' });
  }
});
 
// Criar nova categoria
app.post('/categorias', async (req, res) => {
  try {
    const { nome, descricao } = req.body;
 
    if (!nome) {
      return res.status(400).json({ message: 'Nome da categoria é obrigatório.' });
    }
 
    const [resultado] = await db.query(
      'INSERT INTO categorias (nome, descricao) VALUES (?, ?)',
      [nome, descricao || null]
    );
 
    res.status(201).json({
      id: resultado.insertId,
      nome,
      descricao: descricao || null,
    });
  } catch (error) {
    console.error('Erro ao criar categoria:', error);
    res.status(500).json({ message: 'Erro ao criar categoria.' });
  }
});
 
// Atualizar categoria existente
app.put('/categorias/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { nome, descricao } = req.body;
 
    if (!nome) {
      return res.status(400).json({ message: 'Nome da categoria é obrigatório.' });
    }
 
    const [resultado] = await db.query(
      'UPDATE categorias SET nome = ?, descricao = ? WHERE id = ?',
      [nome, descricao || null, id]
    );
 
    if (resultado.affectedRows === 0) {
      return res.status(404).json({ message: 'Categoria não encontrada.' });
    }
 
    res.json({ id, nome, descricao: descricao || null });
  } catch (error) {
    console.error('Erro ao atualizar categoria:', error);
    res.status(500).json({ message: 'Erro ao atualizar categoria.' });
  }
});
 
// Remover categoria
app.delete('/categorias/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const [resultado] = await db.query('DELETE FROM categorias WHERE id = ?', [id]);
 
    if (resultado.affectedRows === 0) {
      return res.status(404).json({ message: 'Categoria não encontrada.' });
    }
 
    res.status(204).send();
  } catch (error) {
    console.error('Erro ao remover categoria:', error);
    res.status(500).json({ message: 'Erro ao remover categoria.' });
  }
});
 